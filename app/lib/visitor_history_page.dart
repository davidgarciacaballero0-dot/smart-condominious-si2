import 'package:app/models/security_incident_model.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitorHistoryPage extends StatefulWidget {
  const VisitorHistoryPage({super.key});

  @override
  State<VisitorHistoryPage> createState() => _VisitorHistoryPageState();
}

class _VisitorHistoryPageState extends State<VisitorHistoryPage> {
  final ApiService _apiService = ApiService();
  late Future<List<VisitorLog>> _visitorLogsFuture;

  @override
  void initState() {
    super.initState();
    _visitorLogsFuture = _apiService.getVisitorLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Visitas'),
      ),
      body: FutureBuilder<List<VisitorLog>>(
        future: _visitorLogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros de visitas.'));
          }

          final sortedLogs = snapshot.data!
            ..sort((a, b) => b.entryTime.compareTo(a.entryTime));

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sortedLogs.length,
            itemBuilder: (context, index) {
              final log = sortedLogs[index];
              final hasExited = log.exitTime != null;

              return Card(
                color: hasExited ? Colors.white : Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.visitorName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 16),
                      // CORREGIDO: Se asume que el modelo tiene 'residentName' y 'ci'
                      Text('Visita a: ${log.residentName}'),
                      Text('CI: ${log.ci}'),
                      if (log.licensePlate != null)
                        Text('Placa: ${log.licensePlate}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.login, color: Colors.green[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                              'Ingreso: ${DateFormat('dd/MM/yy HH:mm').format(log.entryTime)}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.logout,
                              color: hasExited ? Colors.red[700] : Colors.grey,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            hasExited
                                ? 'Salida: ${DateFormat('dd/MM/yy HH:mm').format(log.exitTime!)}'
                                : 'Aún se encuentra dentro',
                            style: TextStyle(
                              fontStyle: hasExited
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                              color:
                                  hasExited ? Colors.black87 : Colors.grey[600],
                            ),
                          ),
                        ],
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

// --- CORREGIDO: Se ha eliminado la extensión innecesaria de aquí ---
