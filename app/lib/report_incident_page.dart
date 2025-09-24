// ignore_for_file: deprecated_member_use

import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'models/maintenance_task_model.dart'; // Usamos el modelo de Tarea
import 'services/api_service.dart';

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});
  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'media'; // Valor por defecto
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _apiService.createTask(
          _titleController.text,
          _descriptionController.text,
          _selectedPriority,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Incidente reportado con éxito.'),
              backgroundColor: Colors.green));
          Navigator.of(context)
              .pop(true); // Devuelve true para recargar la lista anterior
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar Incidente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Título del Incidente'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese un título'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration:
                    const InputDecoration(labelText: 'Nivel de Prioridad'),
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority.name,
                    child: Text(priority.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Descripción detallada del incidente',
                    alignLabelWithHint: true),
                maxLines: 5,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese una descripción'
                    : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('ENVIAR REPORTE'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
