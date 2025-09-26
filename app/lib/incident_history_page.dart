// app/lib/incident_history_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/feedback_model.dart'; // Usamos el nuevo modelo

class IncidentHistoryPage extends StatefulWidget {
  const IncidentHistoryPage({super.key});

  @override
  State<IncidentHistoryPage> createState() => _IncidentHistoryPageState();
}

class _IncidentHistoryPageState extends State<IncidentHistoryPage> {
  // Como el backend no tiene un endpoint para listar incidentes,
  // creamos un Future que resuelve inmediatamente a una lista vacía.
  // Esto deja la página lista para una futura implementación.
  final Future<List<FeedbackReport>> _futureIncidents = Future.value([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Incidentes'),
      ),
      body: FutureBuilder<List<FeedbackReport>>(
        future: _futureIncidents,
        builder: (context, snapshot) {
          // Aunque la lista esté vacía, mantenemos la estructura correcta
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No hay un historial de incidentes disponible por el momento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            // Este código se ejecutaría si la API devolviera una lista
            final incidents = snapshot.data!;
            return ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.report_problem),
                    title: Text(incident.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(incident.description),
                    trailing: Text(incident.status),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
