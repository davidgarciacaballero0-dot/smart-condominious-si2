import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/mock_data.dart';
import 'models/security_incident_model.dart';

class IncidentHistoryPage extends StatelessWidget {
  const IncidentHistoryPage({super.key});

  // Función para obtener el color y el ícono según la urgencia
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
    final sortedIncidents = mockIncidents.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Incidentes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sortedIncidents.length,
        itemBuilder: (context, index) {
          final incident = sortedIncidents[index];
          final (urgencyColor, urgencyIcon) =
              _getUrgencyStyle(incident.urgency);

          return Card(
            elevation: 4.0,
            child: ListTile(
              leading: Icon(urgencyIcon, color: urgencyColor, size: 40),
              title: Text(
                incident.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Reportado por: ${incident.reportedBy}\n${DateFormat('dd/MM/yyyy HH:mm').format(incident.date)} hrs',
              ),
              isThreeLine: true,
              onTap: () {
                // Muestra un diálogo con los detalles completos del incidente
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(incident.title),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            'Nivel de Urgencia: ${incident.urgency.name.toUpperCase()}',
                            style: TextStyle(
                                color: urgencyColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(incident.description),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
