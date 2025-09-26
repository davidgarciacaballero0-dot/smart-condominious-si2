// app/lib/add_edit_pet_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/services/profile_service.dart';

class AddEditPetPage extends StatefulWidget {
  final Pet? petToEdit;

  const AddEditPetPage({super.key, this.petToEdit});

  @override
  State<AddEditPetPage> createState() => _AddEditPetPageState();
}

class _AddEditPetPageState extends State<AddEditPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;

  bool get _isEditing => widget.petToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.petToEdit?.name ?? '');
    _speciesController =
        TextEditingController(text: widget.petToEdit?.species ?? '');
    _breedController =
        TextEditingController(text: widget.petToEdit?.breed ?? '');
    _colorController =
        TextEditingController(text: widget.petToEdit?.color ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _savePet() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        if (_isEditing) {
          await _profileService.updatePet(
            widget.petToEdit!.id,
            name: _nameController.text,
            species: _speciesController.text,
            breed: _breedController.text,
            color: _colorController.text,
          );
        } else {
          await _profileService.addPet(
            name: _nameController.text,
            species: _speciesController.text,
            breed: _breedController.text,
            color: _colorController.text,
          );
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Mascota guardada con éxito'),
                backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
        title: Text(_isEditing ? 'Editar Mascota' : 'Añadir Mascota'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _speciesController,
              decoration:
                  const InputDecoration(labelText: 'Especie (ej. Perro, Gato)'),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Raza'),
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
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _savePet,
                    child: const Text('Guardar Mascota'),
                  ),
          ],
        ),
      ),
    );
  }
}
