// app/lib/maintenance_task_detail_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:app/models/task_model.dart';
import 'package:app/services/maintenance_service.dart';
import 'package:intl/intl.dart';

class MaintenanceTaskDetailPage extends StatefulWidget {
  final Task task;
  const MaintenanceTaskDetailPage({super.key, required this.task});

  @override
  State<MaintenanceTaskDetailPage> createState() =>
      _MaintenanceTaskDetailPageState();
}

class _MaintenanceTaskDetailPageState extends State<MaintenanceTaskDetailPage> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  late String _currentStatus;
  bool _isLoading = false;
  final List<String> _statusOptions = ['Pending', 'In_Progress', 'Completed'];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

  Future<void> _updateStatus() async {
    setState(() => _isLoading = true);
    try {
      await _maintenanceService.updateTaskStatus(
          widget.task.id, _currentStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Estado actualizado'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true); // Regresar con éxito
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = widget.task.dueDate != null
        ? DateFormat('d MMMM, yyyy', 'es').format(widget.task.dueDate!)
        : 'No especificada';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.task.description,
                style: Theme.of(context).textTheme.bodyLarge),
            const Divider(height: 32),
            Text('Fecha Límite: $dateFormat',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _currentStatus,
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                    value: status, child: Text(status.replaceAll('_', ' ')));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _currentStatus = value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Actualizar Estado',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _updateStatus,
                      child: const Text('Guardar Cambios'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
