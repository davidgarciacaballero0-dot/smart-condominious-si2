// app/lib/add_edit_vehicle_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/profile_models.dart'; // Importamos el modelo Vehicle
import 'package:app/services/profile_service.dart';

class AddEditVehiclePage extends StatefulWidget {
  // CAMBIO 1: Añadimos un vehículo opcional al constructor.
  // Si se pasa un vehículo, estamos en "modo edición". Si es nulo, en "modo añadir".
  final Vehicle? vehicleToEdit;

  const AddEditVehiclePage({super.key, this.vehicleToEdit});

  @override
  State<AddEditVehiclePage> createState() => _AddEditVehiclePageState();
}

class _AddEditVehiclePageState extends State<AddEditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  bool _isLoading = false;

  // Controladores para los campos de texto
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;
  late TextEditingController _licensePlateController;

  // CAMBIO 2: Variable para saber si estamos en modo edición.
  bool get _isEditing => widget.vehicleToEdit != null;

  @override
  void initState() {
    super.initState();
    // CAMBIO 3: Llenamos los controladores con los datos del vehículo si estamos editando.
    _brandController =
        TextEditingController(text: widget.vehicleToEdit?.brand ?? '');
    _modelController =
        TextEditingController(text: widget.vehicleToEdit?.model ?? '');
    _colorController =
        TextEditingController(text: widget.vehicleToEdit?.color ?? '');
    _licensePlateController =
        TextEditingController(text: widget.vehicleToEdit?.licensePlate ?? '');
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        // CAMBIO 4: Decidimos qué método del servicio llamar.
        if (_isEditing) {
          // Modo Edición: llamamos a updateVehicle
          await _profileService.updateVehicle(
            widget.vehicleToEdit!.id,
            brand: _brandController.text,
            model: _modelController.text,
            color: _colorController.text,
            licensePlate: _licensePlateController.text,
          );
        } else {
          // Modo Añadir: llamamos a addVehicle
          await _profileService.addVehicle(
            brand: _brandController.text,
            model: _modelController.text,
            color: _colorController.text,
            licensePlate: _licensePlateController.text,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vehículo guardado con éxito'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true); // Regresamos indicando éxito
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // CAMBIO 5: El título de la página cambia dinámicamente.
        title: Text(_isEditing ? 'Editar Vehículo' : 'Añadir Vehículo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Color'),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _licensePlateController,
              decoration: const InputDecoration(labelText: 'Placa'),
              textCapitalization: TextCapitalization.characters,
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveVehicle,
                    child: const Text('Guardar Vehículo'),
                  ),
          ],
        ),
      ),
    );
  }
}
