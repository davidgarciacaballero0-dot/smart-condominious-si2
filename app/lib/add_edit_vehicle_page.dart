import 'package:flutter/material.dart';
import 'models/profile_models.dart';

class AddEditVehiclePage extends StatefulWidget {
  final Vehicle?
      vehicle; // Recibe un vehículo si estamos editando, o null si estamos añadiendo

  const AddEditVehiclePage({super.key, this.vehicle});

  @override
  State<AddEditVehiclePage> createState() => _AddEditVehiclePageState();
}

class _AddEditVehiclePageState extends State<AddEditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _plateController;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    // Llenamos los campos con los datos del vehículo si estamos editando
    _brandController = TextEditingController(text: widget.vehicle?.brand ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _plateController = TextEditingController(text: widget.vehicle?.plate ?? '');
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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Si el formulario es válido, creamos un nuevo objeto Vehicle
      final newVehicle = Vehicle(
        id: widget.vehicle?.id ??
            DateTime.now()
                .toIso8601String(), // Usamos el ID existente o generamos uno nuevo
        brand: _brandController.text,
        model: _modelController.text,
        plate: _plateController.text,
        color: _colorController.text,
      );
      // Devolvemos el nuevo vehículo a la página anterior
      Navigator.of(context).pop(newVehicle);
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
              ElevatedButton.icon(
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
