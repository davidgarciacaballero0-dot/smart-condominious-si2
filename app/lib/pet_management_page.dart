import 'package:flutter/material.dart';
import 'models/profile_models.dart';
import 'add_edit_pet_page.dart';

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final List<Pet> _pets = [
    const Pet(
        id: '1',
        name: 'Rocky',
        species: 'Perro',
        breed: 'Golden Retriever',
        color: 'Dorado'),
    const Pet(
        id: '2',
        name: 'Mishi',
        species: 'Gato',
        breed: 'Siames',
        color: 'Blanco'),
  ];

  void _addOrEditPet({Pet? pet}) async {
    final result = await Navigator.of(context).push<Pet>(
      MaterialPageRoute(
        builder: (context) => AddEditPetPage(pet: pet),
      ),
    );
    if (result != null) {
      setState(() {
        if (pet != null) {
          final index = _pets.indexWhere((p) => p.id == result.id);
          if (index != -1) _pets[index] = result;
        } else {
          _pets.add(result);
        }
      });
    }
  }

  void _deletePet(String id) {
    setState(() {
      _pets.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Mascota eliminada')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Mascotas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _pets.length,
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.pets, size: 40),
              title: Text(pet.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text('${pet.species} - ${pet.breed}\nColor: ${pet.color}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _addOrEditPet(pet: pet)),
                  IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deletePet(pet.id)),
                ],
              ),
            ),
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
