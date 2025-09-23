import 'package:flutter/material.dart';
import 'data/mock_data.dart';
import 'models/security_incident_model.dart';

class VisitorLogPage extends StatefulWidget {
  const VisitorLogPage({super.key});

  @override
  State<VisitorLogPage> createState() => _VisitorLogPageState();
}

class _VisitorLogPageState extends State<VisitorLogPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ciController = TextEditingController(); // <-- Campo para CI
  final _visitingToController = TextEditingController();
  final _plateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ciController.dispose(); // <-- No olvidar el dispose
    _visitingToController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newLog = VisitorLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        visitorName: _nameController.text,
        visitorCI: _ciController.text, // <-- Guardamos el CI
        visitingTo: _visitingToController.text,
        vehiclePlate:
            _plateController.text.isNotEmpty ? _plateController.text : null,
        entryTime: DateTime.now(),
      );

      mockVisitorLogs.add(newLog);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingreso de visitante registrado con éxito.'),
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
        title: const Text('Registrar Visita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Nombre Completo del Visitante'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Ingrese el nombre'
                    : null,
              ),
              const SizedBox(height: 16),
              // --- CAMPO DE CI AÑADIDO ---
              TextFormField(
                controller: _ciController,
                decoration: const InputDecoration(
                    labelText: 'Cédula de Identidad (CI)'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Ingrese el CI del visitante'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _visitingToController,
                decoration: const InputDecoration(
                    labelText: 'Residente a Quien Visita (ej. Uruguay 20)'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Ingrese el destino'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(
                    labelText: 'Placa del Vehículo (Opcional)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.login_outlined),
                label: const Text('REGISTRAR ENTRADA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
