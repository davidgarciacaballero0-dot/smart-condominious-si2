import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/mock_data.dart';
import 'models/security_incident_model.dart';
import 'report_incident_page.dart';

class AiAlertsPage extends StatelessWidget {
  const AiAlertsPage({super.key});

  // Función para obtener el estilo visual según la urgencia
  (Color, IconData) _getUrgencyStyle(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.baja:
        return (Colors.green, Icons.check_circle_outline);
      case UrgencyLevel.media:
        return (Colors.orange, Icons.warning_amber_rounded);
      case UrgencyLevel.alta:
        return (Colors.red, Icons.error_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedAlerts = mockAiAlerts.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas de IA'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sortedAlerts.length,
        itemBuilder: (context, index) {
          final alert = sortedAlerts[index];
          final (urgencyColor, urgencyIcon) = _getUrgencyStyle(alert.urgency);

          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: urgencyColor, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(urgencyIcon, color: urgencyColor, size: 40),
                    title: Text(
                      alert.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Detectado por: ${alert.reportedBy}\n${DateFormat('dd/MM/yyyy HH:mm').format(alert.date)} hrs',
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(alert.description),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('IGNORAR'),
                        onPressed: () {
                          // Lógica para descartar la alerta
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text('CREAR INCIDENTE'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReportIncidentPage()),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
