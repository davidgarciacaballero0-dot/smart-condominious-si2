// lib/pages/add_edit_vehicle_page.dart
import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class AddEditVehiclePage extends StatefulWidget {
  const AddEditVehiclePage({Key? key}) : super(key: key);

  @override
  _AddEditVehiclePageState createState() => _AddEditVehiclePageState();
}

class _AddEditVehiclePageState extends State<AddEditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  bool _isLoading = false;

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _licensePlateController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final vehicleData = {
        'brand': _brandController.text,
        'model': _modelController.text,
        'color': _colorController.text,
        'license_plate': _licensePlateController.text,
      };

      final newVehicle = await _profileService.createVehicle(vehicleData);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        final success = newVehicle != null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Vehículo añadido con éxito'
                : 'Error al añadir el vehículo'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Nuevo Vehículo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Marca (ej. Toyota)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label_important_outline),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'La marca es requerida' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Modelo (ej. Corolla)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'El modelo es requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.color_lens_outlined),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'El color es requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _licensePlateController,
              decoration: const InputDecoration(
                labelText: 'Placa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pin_outlined),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'La placa es requerida' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              // --- CÓDIGO DEL BOTÓN CORREGIDO ---
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 3, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text('GUARDAR VEHÍCULO'),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
