// app/lib/pet_management_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/services/profile_service.dart';
import 'package:app/add_edit_pet_page.dart'; // Importamos el formulario

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final ProfileService _profileService = ProfileService();
  late Future<List<Pet>> _futurePets;

  @override
  void initState() {
    super.initState();
    _futurePets = _profileService.getPets();
  }

  void _navigateToForm({Pet? pet}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditPetPage(petToEdit: pet),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _futurePets = _profileService.getPets();
      });
    }
  }

  Future<void> _deletePet(int petId) async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content:
            const Text('¿Estás seguro de que deseas eliminar esta mascota?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _profileService.deletePet(petId);
        setState(() {
          _futurePets = _profileService.getPets();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Mascota eliminada con éxito'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
      ),
      body: FutureBuilder<List<Pet>>(
        future: _futurePets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes mascotas registradas.'));
          } else {
            final pets = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return _buildPetCard(pets[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        leading: const Icon(Icons.pets, size: 40, color: Colors.brown),
        title:
            Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Especie: ${pet.species}\nRaza: ${pet.breed}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => _navigateToForm(pet: pet),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deletePet(pet.id),
            ),
          ],
        ),
      ),
    );
  }
}
