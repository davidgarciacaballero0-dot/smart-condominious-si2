import 'package:flutter/material.dart';
import 'models/profile_models.dart';

class AddEditPetPage extends StatefulWidget {
  final Pet? pet; // Recibe una mascota si estamos editando

  const AddEditPetPage({super.key, this.pet});

  @override
  State<AddEditPetPage> createState() => _AddEditPetPageState();
}

class _AddEditPetPageState extends State<AddEditPetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _speciesController = TextEditingController(text: widget.pet?.species ?? '');
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _colorController = TextEditingController(text: widget.pet?.color ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newPet = Pet(
        id: widget.pet?.id ?? DateTime.now().toIso8601String(),
        name: _nameController.text,
        species: _speciesController.text,
        breed: _breedController.text,
        color: _colorController.text,
      );
      Navigator.of(context).pop(newPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Añadir Mascota' : 'Editar Mascota'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la mascota',
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese el nombre'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(
                  labelText: 'Especie (ej. Perro, Gato)',
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese la especie'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Raza'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese la raza'
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
