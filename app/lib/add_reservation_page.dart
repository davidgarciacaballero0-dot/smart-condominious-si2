// app/lib/add_reservation_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:app/models/common_area_model.dart';
import 'package:app/services/reservations_service.dart';
import 'package:intl/intl.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({super.key});

  @override
  State<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _reservationsService = ReservationsService();
  bool _isLoading = false;
  bool _isAreaListLoading = true;

  // Variables de estado para el formulario
  List<CommonArea> _commonAreas = [];
  CommonArea? _selectedArea;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    'Mañana (08:00-12:00)',
    'Tarde (14:00-18:00)',
    'Noche (19:00-23:00)'
  ];

  @override
  void initState() {
    super.initState();
    _loadCommonAreas();
  }

  /// Carga las áreas comunes desde la API para llenar el selector.
  Future<void> _loadCommonAreas() async {
    try {
      final areas = await _reservationsService.getCommonAreas();
      if (mounted) {
        setState(() {
          _commonAreas = areas;
          _isAreaListLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al cargar áreas comunes: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
        setState(() => _isAreaListLoading = false);
      }
    }
  }

  /// Muestra el selector de fecha.
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  /// Guarda la reserva enviando los datos al backend.
  Future<void> _saveReservation() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await _reservationsService.createReservation(
          commonAreaId: _selectedArea!.id,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
          timeSlot: _selectedTimeSlot!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Reserva creada con éxito'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Reserva'),
      ),
      body: _isAreaListLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  DropdownButtonFormField<CommonArea>(
                    value: _selectedArea,
                    items: _commonAreas.map((area) {
                      return DropdownMenuItem(
                          value: area, child: Text(area.name));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedArea = value),
                    decoration: const InputDecoration(labelText: 'Área Común'),
                    validator: (value) =>
                        value == null ? 'Seleccione un área' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat('d MMMM, yyyy', 'es')
                              .format(_selectedDate!),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Reserva',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _pickDate,
                    validator: (value) =>
                        _selectedDate == null ? 'Seleccione una fecha' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTimeSlot,
                    items: _timeSlots.map((slot) {
                      return DropdownMenuItem(value: slot, child: Text(slot));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedTimeSlot = value),
                    decoration: const InputDecoration(labelText: 'Horario'),
                    validator: (value) =>
                        value == null ? 'Seleccione un horario' : null,
                  ),
                  const SizedBox(height: 32),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _saveReservation,
                          child: const Text('Confirmar Reserva'),
                        ),
                ],
              ),
            ),
    );
  }
}
