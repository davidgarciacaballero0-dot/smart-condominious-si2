import 'package:app/add_edit_vehicle_page.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

// CORREGIDO: Ajustamos la ruta del modelo y eliminamos importaciones duplicadas

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({super.key});

  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Vehicle>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    setState(() {
      _vehiclesFuture = _apiService.getVehicles();
    });
  }

  void _addOrEditVehicle({Vehicle? vehicle}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddEditVehiclePage(vehicle: vehicle),
      ),
    );
    if (result == true) {
      _loadVehicles();
    }
  }

  void _deleteVehicle(int id) async {
    try {
      final success = await _apiService.deleteVehicle(id);

      // --- CORRECCIÓN AQUÍ ---
      // Verificamos que el widget siga en pantalla antes de usar su context.
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Vehículo eliminado con éxito'),
              backgroundColor: Colors.green));
          _loadVehicles(); // Recargamos la lista
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No se pudo eliminar el vehículo'),
              backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      // --- CORRECCIÓN AQUÍ ---
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Vehículos'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar vehículos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No tienes vehículos registrados.'));
          }

          final vehicles = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_car, size: 40),
                  title: Text('${vehicle.brand} ${vehicle.model}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Placa: ${vehicle.licensePlate}\nColor: ${vehicle.color}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () => _addOrEditVehicle(vehicle: vehicle),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteVehicle(vehicle.id),
                      ),
                    ],
                  ),
                ),
              );
            },
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
