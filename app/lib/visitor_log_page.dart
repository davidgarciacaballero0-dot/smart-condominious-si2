// Archivo: lib/visitor_log_page.dart
import 'package:flutter/material.dart';

class VisitorLogPage extends StatefulWidget {
  const VisitorLogPage({super.key});

  @override
  State<VisitorLogPage> createState() => _VisitorLogPageState();
}

class _VisitorLogPageState extends State<VisitorLogPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _visitingToController = TextEditingController();
  final _plateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _visitingToController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Lógica para guardar el registro de visita
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
