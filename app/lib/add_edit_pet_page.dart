// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'models/profile_models.dart';
import 'services/api_service.dart';

class AddEditPetPage extends StatefulWidget {
  final Pet? pet;

  const AddEditPetPage({super.key, this.pet});

  @override
  State<AddEditPetPage> createState() => _AddEditPetPageState();
}

class _AddEditPetPageState extends State<AddEditPetPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  bool _isLoading = false;

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

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final name = _nameController.text;
        final species = _speciesController.text;
        final breed = _breedController.text;
        final color = _colorController.text;

        if (widget.pet == null) {
          await _apiService.createPet(name, species, breed, color);
        } else {
          await _apiService.updatePet(
              widget.pet!.id, name, species, breed, color);
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al guardar la mascota: ${e.toString()}'),
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
                decoration:
                    const InputDecoration(labelText: 'Nombre de la mascota'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese el nombre'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(
                    labelText: 'Especie (ej. Perro, Gato)'),
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

extension on ApiService {
  Future<void> updatePet(
      int id, String name, String species, String breed, String color) async {}

  Future<void> createPet(
      String name, String species, String breed, String color) async {}
}
