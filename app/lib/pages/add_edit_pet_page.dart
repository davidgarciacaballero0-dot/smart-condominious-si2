// lib/pages/add_edit_pet_page.dart
import 'package:flutter/material.dart';
import '../services/profile_service.dart';
  
class AddEditPetPage extends StatefulWidget {
  const AddEditPetPage({Key? key}) : super(key: key);

  @override
  _AddEditPetPageState createState() => _AddEditPetPageState();
}

class _AddEditPetPageState extends State<AddEditPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  bool _isLoading = false;

  // Controladores para cada campo del formulario
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Creamos un mapa con los datos del formulario
      final petData = {
        'name': _nameController.text,
        'species': _speciesController.text,
        'breed': _breedController.text,
        'color': _colorController.text,
      };

      // Llamamos al servicio para crear la mascota
      final newPet = await _profileService.createPet(petData);
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        final success = newPet != null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Mascota añadida con éxito'
                : 'Error al añadir la mascota'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          // Si se creó con éxito, cerramos la pantalla del formulario
          // y devolvemos 'true' para que la lista anterior se actualice
          Navigator.pop(context, true);
        }
      }
    }
  }

  @override
  void dispose() {
    // Limpiamos los controladores
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Nueva Mascota'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la mascota',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'El nombre es requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _speciesController,
              decoration: const InputDecoration(
                labelText: 'Especie (ej. Perro, Gato)',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'La especie es requerida' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Raza',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'La raza es requerida' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value ?? '').isEmpty ? 'El color es requerido' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('GUARDAR MASCOTA'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
