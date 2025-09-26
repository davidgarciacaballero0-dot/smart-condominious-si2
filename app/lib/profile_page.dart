// lib/profile_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  late Future<UserProfile> _futureUserProfile;

  @override
  void initState() {
    super.initState();
    _futureUserProfile = _authService.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: FutureBuilder<UserProfile>(
        future: _futureUserProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se pudo cargar el perfil.'));
          }

          final user = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileInfoTile(
                  Icons.person_outline, 'Nombre Completo', user.fullName),
              _buildProfileInfoTile(
                  Icons.email_outlined, 'Correo Electrónico', user.email),
              _buildProfileInfoTile(
                  Icons.phone_outlined, 'Teléfono', user.phoneNumber),
              // Puedes añadir más campos aquí si los tienes
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoTile(IconData icon, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
