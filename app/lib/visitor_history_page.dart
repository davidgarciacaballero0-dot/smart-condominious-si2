// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/mock_data.dart';
import 'models/security_incident_model.dart';

class VisitorHistoryPage extends StatelessWidget {
  const VisitorHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ordenamos la lista para mostrar los registros más recientes primero
    final sortedLogs = mockVisitorLogs.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Visitas'),
      ),
      body: ListView.builder(
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 16),
                  Text('Visita a: ${log.visitingTo}'),
                  // --- AQUÍ ESTÁ LA LÍNEA AÑADIDA ---
                  Text('CI: ${log.visitorCI}'),
                  if (log.vehiclePlate != null)
                    Text('Placa: ${log.vehiclePlate}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.login, color: Colors.green[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Ingreso: ${DateFormat('dd/MM/yy HH:mm').format(log.entryTime)}',
                      ),
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
                          fontStyle:
                              hasExited ? FontStyle.normal : FontStyle.italic,
                          color: hasExited ? Colors.black87 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
