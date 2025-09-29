// lib/pages/add_reservation_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/common_area_model.dart';
import '../services/reservations_service.dart';

class AddReservationPage extends StatefulWidget {
  final List<CommonArea> commonAreas;
  const AddReservationPage({Key? key, required this.commonAreas}) : super(key: key);
  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _reservationsService = ReservationsService();
  final _formKey = GlobalKey<FormState>();
  CommonArea? _selectedArea;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

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
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        locale: const Locale('es', 'ES'));
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))));
    if (picked != null) {
      setState(() {
        if (isStartTime) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, complete todos los campos de fecha y hora.'), backgroundColor: Colors.red));
      return;
    }
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (startMinutes >= endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La hora de fin debe ser posterior a la de inicio.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    final startDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _startTime!.hour, _startTime!.minute);
    final endDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _endTime!.hour, _endTime!.minute);
    final success = await _reservationsService.createReservation(
        commonAreaId: _selectedArea!.id,
        startTime: startDateTime.toIso8601String(),
        endTime: endDateTime.toIso8601String());
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success ? 'Reserva creada con éxito' : 'Error al crear la reserva (posible conflicto de horario)'),
          backgroundColor: success ? Colors.green : Colors.red));
      if (success) Navigator.pop(context, true);
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Seleccionar';
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
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
            DropdownButtonFormField<CommonArea>(
                value: _selectedArea,
                items: widget.commonAreas.map((area) => DropdownMenuItem(value: area, child: Text(area.name))).toList(),
                onChanged: (area) => setState(() => _selectedArea = area),
                decoration: const InputDecoration(labelText: 'Seleccionar Área Común', border: OutlineInputBorder()),
                validator: (value) => value == null ? 'Por favor, seleccione un área' : null),
            const SizedBox(height: 20),
            ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Fecha de la Reserva'),
                subtitle: Text(_selectedDate == null ? 'No seleccionada' : DateFormat('d \'de\' MMMM \'de\' y', 'es_ES').format(_selectedDate!)),
                onTap: _selectDate),
            Row(children: [
              Expanded(child: ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.access_time), title: const Text('Hora Inicio'), subtitle: Text(_formatTime(_startTime)), onTap: () => _selectTime(true))),
              Expanded(child: ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.access_time_filled), title: const Text('Hora Fin'), subtitle: Text(_formatTime(_endTime)), onTap: () => _selectTime(false))),
            ]),
            const SizedBox(height: 40),
            SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitReservation,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar Reserva')))
          ],
        ),
      ),
    );
  }
}