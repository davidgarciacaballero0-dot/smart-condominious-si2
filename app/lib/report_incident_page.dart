import 'package:flutter/material.dart';
import 'models/security_incident_model.dart'; // Importamos el modelo que creamos
import 'data/mock_data.dart'; // <-- 1. AÑADE ESTA IMPORTACIÓN

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  State<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  UrgencyLevel _selectedUrgency = UrgencyLevel.media; // Valor por defecto

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final incident = SecurityIncident(
        id: DateTime.now().toIso8601String(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateTime.now(),
        urgency: _selectedUrgency,
        reportedBy: 'Carlos Rojas', // Esto vendría del usuario logueado
      );

      // Añadimos el nuevo incidente a nuestra lista de datos
      mockIncidents.add(incident);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidente reportado con éxito.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Incidente'),
      ),
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
              DropdownButtonFormField<UrgencyLevel>(
                initialValue: _selectedUrgency,
                decoration:
                    const InputDecoration(labelText: 'Nivel de Urgencia'),
                items: UrgencyLevel.values.map((UrgencyLevel level) {
                  return DropdownMenuItem<UrgencyLevel>(
                    value: level,
                    child: Text(level.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (UrgencyLevel? newValue) {
                  setState(() {
                    _selectedUrgency = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción detallada del incidente',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, ingrese una descripción'
                    : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
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
