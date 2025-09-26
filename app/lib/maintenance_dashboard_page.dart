// app/lib/maintenance_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/task_model.dart';
import 'package:app/services/maintenance_service.dart';
import 'package:app/maintenance_task_detail_page.dart';
import 'package:intl/intl.dart';

class MaintenanceDashboardPage extends StatefulWidget {
  const MaintenanceDashboardPage({super.key});

  @override
  State<MaintenanceDashboardPage> createState() =>
      _MaintenanceDashboardPageState();
}

class _MaintenanceDashboardPageState extends State<MaintenanceDashboardPage> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  late Future<List<Task>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = _maintenanceService.getTasks();
  }

  void _navigateToDetailAndRefresh(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MaintenanceTaskDetailPage(task: task)),
    );
    if (result == true && mounted) {
      setState(() {
        _futureTasks = _maintenanceService.getTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas de Mantenimiento'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes tareas asignadas.'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskCard(task);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final statusInfo = _getStatusInfo(task.status);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(Icons.build, color: statusInfo['color']),
        title: Text(task.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Estado: ${task.status}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToDetailAndRefresh(task),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return {'color': Colors.green};
      case 'in_progress':
        return {'color': Colors.orange};
      default:
        return {'color': Colors.grey};
    }
  }
}
