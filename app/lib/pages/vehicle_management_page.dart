// lib/pages/vehicle_management_page.dart
import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/profile_service.dart';
import 'add_edit_vehicle_page.dart'; // <-- Importamos la página del formulario

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({Key? key}) : super(key: key);

  @override
  _VehicleManagementPageState createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  final _profileService = ProfileService();
  Future<List<Vehicle>>? _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    setState(() {
      _vehiclesFuture = _profileService.getMyVehicles();
    });
  }

  Future<void> _deleteVehicle(int vehicleId) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este vehículo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _profileService.deleteVehicle(vehicleId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Vehículo eliminado con éxito'
                : 'Error al eliminar el vehículo'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
      if (success) {
        _loadVehicles();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Vehículos'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadVehicles(),
        child: FutureBuilder<List<Vehicle>>(
          future: _vehiclesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Error al cargar los vehículos.'));
            }
            final vehicles = snapshot.data ?? [];
            if (vehicles.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes vehículos registrados.\nAñade uno con el botón de abajo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return _buildVehicleCard(vehicle);
              },
            );
          },
        ),
      ),
      // --- CÓDIGO DEL BOTÓN ACTUALIZADO ---
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega a la página del formulario y espera un resultado
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditVehiclePage()),
          );
          // Si el formulario devolvió 'true' (porque se guardó con éxito),
          // recargamos la lista de vehículos.
          if (result == true) {
            _loadVehicles();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.directions_car, size: 40),
        title: Text(
          '${vehicle.brand} ${vehicle.model}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text('Placa: ${vehicle.licensePlate} - Color: ${vehicle.color}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteVehicle(vehicle.id),
        ),
      ),
    );
  }
}
