// lib/pages/maintenance_tasks_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/security_service.dart';

class MaintenanceTasksPage extends StatefulWidget {
  const MaintenanceTasksPage({Key? key}) : super(key: key);

  @override
  _MaintenanceTasksPageState createState() => _MaintenanceTasksPageState();
}

class _MaintenanceTasksPageState extends State<MaintenanceTasksPage> {
  final _securityService = SecurityService();
  Future<List<Task>>? _tasksFuture;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasksFuture = _securityService.getMyTasks();
    });
  }

  Future<void> _updateTaskStatus(Task task, String newStatus) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Cambio de Estado'),
        content:
            Text('¿Deseas cambiar el estado de esta tarea a "$newStatus"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, Cambiar')),
        ],
      ),
    );

    if (confirm == true) {
      final success =
          await _securityService.updateTaskStatus(task.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Tarea actualizada con éxito'
                : 'Error al actualizar la tarea'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
      if (success) {
        _loadTasks(); // Recargamos la lista para ver el cambio
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Asignadas'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadTasks(),
        child: FutureBuilder<List<Task>>(
          future: _tasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar las tareas.'));
            }
            final tasks = snapshot.data ?? [];
            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes tareas asignadas.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskCard(task);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final bool isCompleted = task.status == 'Completada';
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isCompleted ? Colors.green : Colors.orange,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Creada: ${DateFormat('dd/MM/yyyy').format(task.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(height: 20),
            Text(task.description),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(task.status),
                  backgroundColor:
                      isCompleted ? Colors.green[100] : Colors.orange[100],
                ),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: () => _updateTaskStatus(task, 'Completada'),
                    child: const Text('Marcar como Completada'),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
