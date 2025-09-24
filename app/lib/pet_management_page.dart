import 'package:app/add_edit_pet_page.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

// CORREGIDO: Ajustamos la ruta del modelo de Pet

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Pet>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    setState(() {
      _petsFuture = _apiService.getPets();
    });
  }

  void _addOrEditPet({Pet? pet}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddEditPetPage(pet: pet),
      ),
    );
    if (result == true) {
      _loadPets();
    }
  }

  void _deletePet(int id) async {
    try {
      final success = await _apiService.deletePet(id);

      // --- CORRECCIÓN AQUÍ ---
      // Verificamos que el widget siga en pantalla antes de usar su context.
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Mascota eliminada con éxito'),
              backgroundColor: Colors.green));
          _loadPets();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No se pudo eliminar la mascota'),
              backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      // --- CORRECCIÓN AQUÍ ---
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Mascotas')),
      body: FutureBuilder<List<Pet>>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar mascotas: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes mascotas registradas.'));
          }

          final pets = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.pets, size: 40),
                  title: Text(pet.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${pet.species} - ${pet.breed}\nColor: ${pet.color}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: Colors.blue),
                          onPressed: () => _addOrEditPet(pet: pet)),
                      IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _deletePet(pet.id)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditPet(),
        label: const Text('Añadir Mascota'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
