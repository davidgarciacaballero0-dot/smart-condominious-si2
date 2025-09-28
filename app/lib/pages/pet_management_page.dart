// lib/pages/pet_management_page.dart
import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/profile_service.dart';
import 'add_edit_pet_page.dart'; // <-- Importamos la página del formulario


class PetManagementPage extends StatefulWidget {
  const PetManagementPage({Key? key}) : super(key: key);

  @override
  _PetManagementPageState createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final _profileService = ProfileService();
  Future<List<Pet>>? _petsFuture;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    setState(() {
      _petsFuture = _profileService.getMyPets();
    });
  }

  Future<void> _deletePet(int petId) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta mascota?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _profileService.deletePet(petId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Mascota eliminada con éxito'
                : 'Error al eliminar la mascota'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
      if (success) {
        _loadPets();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Mascotas'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadPets(),
        child: FutureBuilder<List<Pet>>(
          future: _petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar las mascotas.'));
            }
            final pets = snapshot.data ?? [];
            if (pets.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes mascotas registradas.\nAñade una con el botón de abajo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return _buildPetCard(pet);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditPetPage()),
          );
          if (result == true) {
            _loadPets();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.pets, size: 40),
        title: Text(
          pet.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${pet.species} - ${pet.breed} - Color: ${pet.color}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deletePet(pet.id),
        ),
      ),
    );
  }
}
