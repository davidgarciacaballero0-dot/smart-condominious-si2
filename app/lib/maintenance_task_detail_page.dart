import 'package:app/models/maintenance_task_model.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceTaskDetailPage extends StatefulWidget {
  final MaintenanceTask task;
  const MaintenanceTaskDetailPage({super.key, required this.task});

  @override
  State<MaintenanceTaskDetailPage> createState() =>
      _MaintenanceTaskDetailPageState();
}

class _MaintenanceTaskDetailPageState extends State<MaintenanceTaskDetailPage> {
  final ApiService _apiService = ApiService();
  late TaskStatus _currentStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

  Future<void> _updateTaskStatus(TaskStatus newStatus) async {
    setState(() => _isLoading = true);
    try {
      // Convertimos nuestro enum a el string que espera el backend
      String statusString = newStatus
          .toString()
          .split('.')
          .last
          .replaceFirst('enProgreso', 'in_progress')
          .replaceFirst('completada', 'completed');

      final success =
          await _apiService.updateTaskStatus(widget.task.id, statusString);

      if (success && mounted) {
        setState(() {
          _currentStatus = newStatus;
          widget.task.status =
              newStatus; // Actualizamos el objeto original también
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Estado actualizado con éxito'),
            backgroundColor: Colors.green));
      } else {
        _showErrorDialog('No se pudo actualizar el estado.');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(message),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'))
                ],
              ));
    }
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
            _buildDetailRow(Icons.person_outline, 'Asignado a',
                widget.task.assignedTo ?? 'N/A'),
            _buildDetailRow(Icons.info_outline, 'Estado Actual',
                _getStatusText(_currentStatus)),
            const Divider(height: 32),
            const Text('Descripción:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.task.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_currentStatus != TaskStatus.completada)
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
      child: Row(children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 16),
        Text('$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ]),
    );
  }
}
