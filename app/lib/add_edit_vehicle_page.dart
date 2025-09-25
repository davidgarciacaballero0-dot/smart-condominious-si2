// ignore_for_file: unused_element

import 'package:app/models/profile_models.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class AddEditVehiclePage extends StatefulWidget {
  final Vehicle? vehicle;

  const AddEditVehiclePage({super.key, this.vehicle});

  @override
  State<AddEditVehiclePage> createState() => _AddEditVehiclePageState();
}

class _AddEditVehiclePageState extends State<AddEditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService =
      ApiService(); // <-- 2. Instanciamos el servicio
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _plateController;
  late TextEditingController _colorController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.vehicle?.brand ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _plateController =
        TextEditingController(text: widget.vehicle?.licensePlate ?? '');
    _colorController = TextEditingController(text: widget.vehicle?.color ?? '');
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  // --- 3. NUEVA LÓGICA DE GUARDADO CON API ---
  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final brand = _brandController.text;
        final model = _modelController.text;
        final licensePlate = _plateController.text;
        final color = _colorController.text;

        if (widget.vehicle == null) {
          // Crear nuevo vehículo
          await _apiService._apiService
              .createVehicle(brand, model, licensePlate, color);
        } else {
          // Actualizar vehículo existente
          await _apiService.updateVehicle(
              widget.vehicle!.id, brand, model, licensePlate, color);
        }

        if (mounted) {
          // Si todo fue exitoso, volvemos a la página anterior y le decimos que recargue (true)
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al guardar el vehículo: ${e.toString()}'),
                backgroundColor: Colors.red),
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
        title: Text(
            widget.vehicle == null ? 'Añadir Vehículo' : 'Editar Vehículo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _brandController,
                decoration:
                    const InputDecoration(labelText: 'Marca (ej. Toyota)'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese la marca'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration:
                    const InputDecoration(labelText: 'Modelo (ej. Corolla)'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese el modelo'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese la placa'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese el color'
                    : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _saveForm,
                      icon: const Icon(Icons.save_alt_outlined),
                      label: const Text('GUARDAR'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Future<Null> {
  Future<void> createVehicle(
      String brand, String model, String licensePlate, String color) async {}
}

extension on ApiService {
  Future<Null> get _apiService async {
    return null;
  }

  Future<void> updateVehicle(int id, String brand, String model,
      String licensePlate, String color) async {}
}
