// ignore_for_file: unused_element

import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/security_incident_model.dart';
import 'services/api_service.dart';

class VisitorExitPage extends StatefulWidget {
  const VisitorExitPage({super.key});

  @override
  State<VisitorExitPage> createState() => _VisitorExitPageState();
}

class _VisitorExitPageState extends State<VisitorExitPage> {
  final ApiService _apiService = ApiService();
  late Future<List<VisitorLog>> _activeVisitorsFuture;

  @override
  void initState() {
    super.initState();
    _loadActiveVisitors();
  }

  void _loadActiveVisitors() {
    setState(() {
      _activeVisitorsFuture = _apiService.getActiveVisitors();
    });
  }

  Future<void> _registerExit(int id) async {
    try {
      final success = await _apiService.registerVisitorExit(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Salida registrada con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
        // Si la salida fue exitosa, recargamos la lista de visitantes activos
        _loadActiveVisitors();
      } else {
        _showErrorDialog('No se pudo registrar la salida.');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Salida de Visitante'),
      ),
      body: FutureBuilder<List<VisitorLog>>(
        future: _activeVisitorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay visitantes registrados actualmente.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }

          final visitors = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              final visitor = visitors[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitor.visitorName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Visita a: ${visitor.visitingTo}'),
                      Text('CI: ${visitor.visitorCI}'),
                      if (visitor.licensePlate != null)
                        Text('Placa: ${visitor.licensePlate}'),
                      const SizedBox(height: 4),
                      Text(
                        'Ingreso: ${DateFormat('dd/MM/yyyy HH:mm').format(visitor.entryTime)} hrs',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _registerExit(visitor.id),
                          icon: const Icon(Icons.logout_outlined),
                          label: const Text('REGISTRAR SALIDA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension on ApiService {
  Future<List<VisitorLog>> getActiveVisitors() async {}

  Future registerVisitorExit(int id) async {}
}
