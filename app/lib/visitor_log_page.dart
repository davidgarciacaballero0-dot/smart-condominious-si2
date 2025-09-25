// ignore_for_file: unused_element

import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'services/api_service.dart';

class VisitorLogPage extends StatefulWidget {
  const VisitorLogPage({super.key});

  @override
  State<VisitorLogPage> createState() => _VisitorLogPageState();
}

class _VisitorLogPageState extends State<VisitorLogPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _ciController = TextEditingController();
  final _visitingToController = TextEditingController();
  final _plateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ciController.dispose();
    _visitingToController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _apiService.createVisitorLog(
          _nameController.text,
          _ciController.text,
          _visitingToController.text,
          _plateController.text.isNotEmpty ? _plateController.text : null,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ingreso de visitante registrado con éxito.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true); // Devuelve 'true' para indicar éxito
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red),
          );
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
                    labelText: 'Residente a Quien Visita'),
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
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
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

extension on ApiService {
  Future<void> createVisitorLog(
      String text, String text2, String text3, String? s) async {}
}
