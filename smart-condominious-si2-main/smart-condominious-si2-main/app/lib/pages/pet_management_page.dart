import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/profile_service.dart';
import 'add_edit_pet_page.dart';

class PetManagementPage extends StatefulWidget {
  @override
  _PetManagementPageState createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  List<Pet> _pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Pet> pets = await _profileService.getMyPets();
      setState(() {
        _pets = pets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar mascotas: ${e.toString()}')),
      );
    }
  }

  void _deletePet(int petId) async {
    try {
      await _profileService.deletePet(petId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mascota eliminada con éxito')),
      );
      _loadPets(); // Recargar la lista después de eliminar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al eliminar la mascota: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Mis Mascotas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pets.isEmpty
              ? Center(
                  child: Text(
                    'No tienes mascotas registradas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _pets.length,
                  itemBuilder: (context, index) {
                    final pet = _pets[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(pet.name),
                        subtitle: Text(
                            'Especie: ${pet.species} - Raza: ${pet.breed}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePet(pet.id),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega a la página de añadir/editar y ESPERA el resultado.
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditPetPage(),
            ),
          );

          // Si el resultado es 'true', significa que se guardó una mascota.
          // Por lo tanto, recargamos la lista.
          if (result == true) {
            _loadPets();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Añadir Mascota',
      ),
    );
  }
}
