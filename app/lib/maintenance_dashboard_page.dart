// ignore_for_file: duplicate_import, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/mock_data.dart';
import 'login_page.dart';
import 'models/maintenance_task_model.dart';
import 'maintenance_task_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:app/dashboard_page.dart';

class MaintenanceDashboardPage extends StatefulWidget {
  const MaintenanceDashboardPage({super.key});
  @override
  State<MaintenanceDashboardPage> createState() =>
      _MaintenanceDashboardPageState();
}

class _MaintenanceDashboardPageState extends State<MaintenanceDashboardPage> {
  (Color, IconData) _getPriorityStyle(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.baja:
        return (Colors.green, Icons.arrow_downward);
      case TaskPriority.media:
        return (Colors.orange, Icons.remove);
      case TaskPriority.alta:
        return (Colors.red, Icons.arrow_upward);
    }
  }

  (String, Color) _getStatusStyle(TaskStatus status) {
    switch (status) {
      case TaskStatus.pendiente:
        return ('Pendiente', Colors.grey.shade700);
      case TaskStatus.enProgreso:
        return ('En Progreso', Colors.blue.shade700);
      case TaskStatus.completada:
        return ('Completada', Colors.green.shade800);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = List<MaintenanceTask>.from(mockMaintenanceTasks)
      ..sort((a, b) {
        if (a.status == TaskStatus.completada &&
            b.status != TaskStatus.completada) return 1;
        if (a.status != TaskStatus.completada &&
            b.status == TaskStatus.completada) return -1;
        return b.dateReported.compareTo(a.dateReported);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas de Mantenimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sortedTasks.length,
        itemBuilder: (context, index) {
          final task = sortedTasks[index];
          final (priorityColor, priorityIcon) =
              _getPriorityStyle(task.priority);
          final (statusText, statusColor) = _getStatusStyle(task.status);

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: Tooltip(
                message: 'Prioridad ${task.priority.name}',
                child: Icon(priorityIcon, color: priorityColor, size: 30),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task.status == TaskStatus.completada
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                  'Reportado: ${DateFormat('dd/MM/yyyy').format(task.dateReported)}'),
              trailing: Chip(
                label: Text(statusText,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: statusColor,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MaintenanceTaskDetailPage(task: task)),
                );
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
