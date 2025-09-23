import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/maintenance_task_model.dart';

class MaintenanceTaskDetailPage extends StatefulWidget {
  final MaintenanceTask task;

  const MaintenanceTaskDetailPage({super.key, required this.task});

  @override
  State<MaintenanceTaskDetailPage> createState() =>
      _MaintenanceTaskDetailPageState();
}

class _MaintenanceTaskDetailPageState extends State<MaintenanceTaskDetailPage> {
  late TaskStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

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

  void _updateTaskStatus(TaskStatus newStatus) {
    setState(() {
      widget.task.status = newStatus;
      _currentStatus = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea actualizada a "${_getStatusText(newStatus)}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pendiente:
        return 'Pendiente';
      case TaskStatus.enProgreso:
        return 'En Progreso';
      case TaskStatus.completada:
        return 'Completada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final (priorityColor, _) = _getPriorityStyle(widget.task.priority);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Tarea')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Chip(
              label: Text(
                  'Prioridad: ${widget.task.priority.name.toUpperCase()}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: priorityColor,
            ),
            const Divider(height: 32),
            _buildDetailRow(
                Icons.calendar_today,
                'Reportado',
                DateFormat('dd/MM/yyyy HH:mm')
                    .format(widget.task.dateReported)),
            _buildDetailRow(
                Icons.person_outline, 'Asignado a', widget.task.assignedTo),
            _buildDetailRow(Icons.info_outline, 'Estado Actual',
                _getStatusText(_currentStatus)),
            const Divider(height: 32),
            const Text('Descripción:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.task.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            if (_currentStatus != TaskStatus.completada)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Actualizar Estado:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  if (_currentStatus == TaskStatus.pendiente)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('INICIAR TAREA'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () => _updateTaskStatus(TaskStatus.enProgreso),
                    ),
                  if (_currentStatus == TaskStatus.enProgreso)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text('MARCAR COMO COMPLETADA'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () => _updateTaskStatus(TaskStatus.completada),
                    ),
                ],
              )
            else
              Center(
                child: Chip(
                  avatar: Icon(Icons.check_circle, color: Colors.green[800]),
                  label: Text('Tarea Completada',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800])),
                  padding: const EdgeInsets.all(12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text('$label: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
