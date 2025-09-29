import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/profile_service.dart';
import 'add_edit_vehicle_page.dart';

class VehicleManagementPage extends StatefulWidget {
  @override
  _VehicleManagementPageState createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  List<Vehicle> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Vehicle> vehicles = await _profileService.getMyVehicles();
      setState(() {
        _vehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar vehículos: ${e.toString()}')),
      );
    }
  }

  void _deleteVehicle(int vehicleId) async {
    try {
      await _profileService.deleteVehicle(vehicleId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehículo eliminado con éxito')),
      );
      _loadVehicles(); // Recargar la lista después de eliminar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al eliminar el vehículo: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Mis Vehículos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _vehicles.isEmpty
              ? Center(
                  child: Text(
                    'No tienes vehículos registrados.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('${vehicle.brand} ${vehicle.model}'),
                        subtitle: Text(
                            'Placa: ${vehicle.licensePlate} - Color: ${vehicle.color}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteVehicle(vehicle.id),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega a la página de añadir/editar y ESPERA el resultado.
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditVehiclePage(),
            ),
          );

          // Si el resultado es 'true', significa que se guardó un vehículo.
          // Por lo tanto, recargamos la lista.
          if (result == true) {
            _loadVehicles();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Añadir Vehículo',
      ),
    );
  }
}
