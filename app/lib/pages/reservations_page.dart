// lib/pages/add_reservation_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/common_area_model.dart';
import '../services/reservations_service.dart';

class AddReservationPage extends StatefulWidget {
  final List<CommonArea> commonAreas;
  const AddReservationPage({Key? key, required this.commonAreas})
      : super(key: key);
  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _reservationsService = ReservationsService();
  CommonArea? _selectedArea;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.commonAreas.isNotEmpty) {
      _selectedArea = widget.commonAreas.first;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 90)));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    // Combinar fecha y hora
    final startDateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, _startTime!.hour, _startTime!.minute);
    final endDateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, _endTime!.hour, _endTime!.minute);

    final success = await _reservationsService.createReservation(
      commonAreaId: _selectedArea!.id,
      // Convertir a formato ISO8601 que el backend espera
      startTime: startDateTime.toIso8601String(),
      endTime: endDateTime.toIso8601String(),
    );

    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Reserva creada con éxito'
              : 'Error al crear la reserva (posible conflicto de horario)'),
          backgroundColor: success ? Colors.green : Colors.red));
      if (success) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Nueva Reserva')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Selección de Área
            DropdownButtonFormField<CommonArea>(
              value: _selectedArea,
              items: widget.commonAreas
                  .map((area) =>
                      DropdownMenuItem(value: area, child: Text(area.name)))
                  .toList(),
              onChanged: (area) => setState(() => _selectedArea = area),
              decoration: const InputDecoration(
                  labelText: 'Seleccionar Área Común',
                  border: OutlineInputBorder()),
              validator: (value) =>
                  value == null ? 'Por favor, seleccione un área' : null,
            ),
            const SizedBox(height: 20),
            // Selección de Fecha
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha de la Reserva'),
              subtitle: Text(_selectedDate == null
                  ? 'No seleccionada'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
              onTap: _selectDate,
            ),
            // Selección de Hora
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Hora Inicio'),
                    subtitle: Text(_startTime == null
                        ? 'No seleccionada'
                        : _startTime!.format(context)),
                    onTap: () => _selectTime(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.access_time_filled),
                    title: const Text('Hora Fin'),
                    subtitle: Text(_endTime == null
                        ? 'No seleccionada'
                        : _endTime!.format(context)),
                    onTap: () => _selectTime(false),
                  ),
                ),
              ],
            ),
            // Validadores "invisibles" para fecha y hora
            if (_selectedDate == null)
              TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                      errorText: 'Seleccione una fecha',
                      border: InputBorder.none)),
            if (_startTime == null)
              TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                      errorText: 'Seleccione hora de inicio',
                      border: InputBorder.none)),
            if (_endTime == null)
              TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                      errorText: 'Seleccione hora de fin',
                      border: InputBorder.none)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReservation,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Confirmar Reserva'),
            )
          ],
        ),
      ),
    );
  }
}
