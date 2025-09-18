import 'package:flutter/material.dart';
import 'models/profile_models.dart';
import 'add_edit_vehicle_page.dart'; // <-- IMPORTAMOS LA PÁGINA DEL FORMULARIO

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({super.key});

  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  // Datos de prueba
  final List<Vehicle> _vehicles = [
    const Vehicle(
        id: '1',
        brand: 'Toyota',
        model: 'Corolla',
        plate: '2457GTH',
        color: 'Plata'),
    const Vehicle(
        id: '2',
        brand: 'Nissan',
        model: 'Versa',
        plate: '3829POK',
        color: 'Rojo'),
  ];

  // --- LÓGICA ACTUALIZADA PARA ABRIR EL FORMULARIO ---
  void _addOrEditVehicle({Vehicle? vehicle}) async {
    // Navegamos al formulario y esperamos el resultado
    final result = await Navigator.of(context).push<Vehicle>(
      MaterialPageRoute(
        builder: (context) => AddEditVehiclePage(vehicle: vehicle),
      ),
    );

    // Si el formulario nos devuelve un vehículo (es decir, se guardó), actualizamos la lista
    if (result != null) {
      setState(() {
        if (vehicle != null) {
          // Editando: Buscamos el índice y reemplazamos
          final index = _vehicles.indexWhere((v) => v.id == result.id);
          _vehicles[index] = result;
        } else {
          // Añadiendo: Simplemente lo agregamos a la lista
          _vehicles.add(result);
        }
      });
    }
  }

  void _deleteVehicle(String id) {
    setState(() {
      _vehicles.removeWhere((v) => v.id == id);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Vehículo eliminado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Vehículos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = _vehicles[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.directions_car, size: 40),
              title: Text('${vehicle.brand} ${vehicle.model}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text('Placa: ${vehicle.plate}\nColor: ${vehicle.color}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () => _addOrEditVehicle(vehicle: vehicle),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteVehicle(vehicle.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditVehicle(),
        label: const Text('Añadir Vehículo'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
