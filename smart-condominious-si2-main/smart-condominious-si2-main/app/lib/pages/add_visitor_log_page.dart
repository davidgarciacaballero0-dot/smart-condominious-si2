// lib/pages/add_visitor_log_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/security_service.dart';

class AddVisitorLogPage extends StatefulWidget {
  const AddVisitorLogPage({Key? key}) : super(key: key);

  @override
  _AddVisitorLogPageState createState() => _AddVisitorLogPageState();
}

class _AddVisitorLogPageState extends State<AddVisitorLogPage> {
  final _formKey = GlobalKey<FormState>();
  final _securityService = SecurityService();
  bool _isLoading = false;
  File? _visitorPhoto;

  final _fullNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _companyController = TextEditingController();
  final _reasonController = TextEditingController();
  final _unitController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _visitorPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final visitorData = {
        'full_name': _fullNameController.text,
        'dni': _dniController.text,
        'company': _companyController.text,
        'reason_for_visit': _reasonController.text,
        'housing_unit_id':
            _unitController.text, // El backend espera el ID de la unidad
      };

      final success = await _securityService.createVisitorLog(
        visitorData: visitorData,
        visitorPhoto: _visitorPhoto,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Entrada de visitante registrada'
                : 'Error al registrar la entrada'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Visitante'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Sección para la foto
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _visitorPhoto != null
                        ? FileImage(_visitorPhoto!)
                        : null,
                    child: _visitorPhoto == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => _showImageSourceActionSheet(context),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null),
            TextFormField(
                controller: _dniController,
                decoration: const InputDecoration(labelText: 'DNI o Cédula'),
                validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null),
            TextFormField(
                controller: _companyController,
                decoration:
                    const InputDecoration(labelText: 'Empresa (Opcional)')),
            TextFormField(
                controller: _reasonController,
                decoration:
                    const InputDecoration(labelText: 'Motivo de la Visita'),
                validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null),
            TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                    labelText: 'ID de la Unidad Habitacional a Visitar'),
                keyboardType: TextInputType.number,
                validator: (v) => (v ?? '').isEmpty ? 'Campo requerido' : null),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('REGISTRAR ENTRADA'),
            )
          ],
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Cámara'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
