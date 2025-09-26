// lib/visitor_log_page.dart

import 'package:flutter/material.dart';
import 'package:app/services/security_service.dart';

class VisitorLogPage extends StatefulWidget {
  const VisitorLogPage({super.key});

  @override
  State<VisitorLogPage> createState() => _VisitorLogPageState();
}

class _VisitorLogPageState extends State<VisitorLogPage> {
  final _formKey = GlobalKey<FormState>();
  final _securityService = SecurityService();
  bool _isLoading = false;

  final _residentNameController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _visitorDocController = TextEditingController();

  @override
  void dispose() {
    _residentNameController.dispose();
    _visitorNameController.dispose();
    _visitorDocController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await _securityService.registerVisitorEntry(
          residentName: _residentNameController.text,
          visitorFullName: _visitorNameController.text,
          visitorDocumentNumber: _visitorDocController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Entrada registrada con éxito'),
                backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(true);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Entrada de Visitante')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _visitorNameController,
              decoration: const InputDecoration(
                  labelText: 'Nombre Completo del Visitante'),
              validator: (v) =>
                  (v?.isEmpty ?? true) ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _visitorDocController,
              decoration:
                  const InputDecoration(labelText: 'Documento del Visitante'),
              validator: (v) =>
                  (v?.isEmpty ?? true) ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _residentNameController,
              decoration: const InputDecoration(
                  labelText: 'Nombre del Residente a Visitar'),
              validator: (v) =>
                  (v?.isEmpty ?? true) ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveEntry,
                    child: const Text('Registrar Entrada')),
          ],
        ),
      ),
    );
  }
}
