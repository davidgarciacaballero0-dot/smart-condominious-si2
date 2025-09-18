// ignore_for_file: library_private_types_in_public_api

import 'package:app/vehicle_management_page.dart';
import 'package:flutter/material.dart';
import 'models/profile_models.dart';

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  _VehicleManagementPageState createState() => _VehicleManagementPageState();
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

  void _addOrEditVehicle({Vehicle? vehicle}) {
    // Lógica para mostrar un formulario (la crearemos más adelante)
    // Por ahora, solo simula añadir un vehículo
    setState(() {
      if (vehicle == null) {
        _vehicles.add(
          Vehicle(
              id: '${_vehicles.length + 1}',
              brand: 'Nueva Marca',
              model: 'Nuevo Modelo',
              plate: '1234ABC',
              color: 'Nuevo Color'),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehículo añadido (simulación)')));
      }
    });
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
