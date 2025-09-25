import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/maintenance_task_model.dart'; // Usamos el modelo de Tarea
import 'services/api_service.dart';

class IncidentHistoryPage extends StatefulWidget {
  const IncidentHistoryPage({super.key});
  @override
  State<IncidentHistoryPage> createState() => _IncidentHistoryPageState();
}

class _IncidentHistoryPageState extends State<IncidentHistoryPage> {
  final ApiService _apiService = ApiService();
  late Future<List<MaintenanceTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _apiService.getTasks();
  }

  (Color, IconData) _getPriorityStyle(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.baja:
        return (Colors.green, Icons.check_circle_outline);
      case TaskPriority.media:
        return (Colors.orange, Icons.warning_amber_rounded);
      case TaskPriority.alta:
        return (Colors.red, Icons.error_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Incidentes')),
      body: FutureBuilder<List<MaintenanceTask>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay incidentes reportados.'));
          }

          final incidents = snapshot.data!
            ..sort((a, b) => b.dateReported.compareTo(a.dateReported));

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              final incident = incidents[index];
              final (priorityColor, priorityIcon) =
                  _getPriorityStyle(incident.priority);

              return Card(
                elevation: 4.0,
                child: ListTile(
                  leading: Icon(priorityIcon, color: priorityColor, size: 40),
                  title: Text(incident.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Reportado por: ${incident.assignedTo ?? "N/A"}\n${DateFormat('dd/MM/yyyy HH:mm').format(incident.dateReported)} hrs',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
