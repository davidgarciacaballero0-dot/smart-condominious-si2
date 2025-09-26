// app/lib/vehicle_management_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/services/profile_service.dart';
import 'package:app/add_edit_vehicle_page.dart';

class VehicleManagementPage extends StatefulWidget {
  const VehicleManagementPage({super.key});

  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  final ProfileService _profileService = ProfileService();
  late Future<List<Vehicle>> _futureVehicles;

  @override
  void initState() {
    super.initState();
    _futureVehicles = _profileService.getVehicles();
  }

  void _navigateToForm({Vehicle? vehicle}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditVehiclePage(vehicleToEdit: vehicle),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _futureVehicles = _profileService.getVehicles();
      });
    }
  }

  /// Muestra un diálogo de confirmación y elimina el vehículo si se confirma.
  Future<void> _deleteVehicle(int vehicleId) async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este vehículo? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // No confirmar
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirmar
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _profileService.deleteVehicle(vehicleId);
        // Refrescamos la lista para que el vehículo eliminado desaparezca
        setState(() {
          _futureVehicles = _profileService.getVehicles();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Vehículo eliminado con éxito'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: _futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No tienes vehículos registrados.'));
          } else {
            final vehicles = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return _buildVehicleCard(vehicles[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        leading:
            const Icon(Icons.directions_car, size: 40, color: Colors.blueGrey),
        title: Text(
          '${vehicle.brand} ${vehicle.model}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text('Placa: ${vehicle.licensePlate}\nColor: ${vehicle.color}'),
        isThreeLine: true,
        // CAMBIO: El trailing ahora es una fila con dos botones
        trailing: Row(
          mainAxisSize:
              MainAxisSize.min, // Para que la fila ocupe el mínimo espacio
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => _navigateToForm(vehicle: vehicle),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () =>
                  _deleteVehicle(vehicle.id), // Llamamos al método de borrado
            ),
          ],
        ),
      ),
    );
  }
}
