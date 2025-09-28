// lib/pages/add_reservation_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.commonAreas.isNotEmpty) {
      _selectedArea = widget.commonAreas.first;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitReservation() async {
    if (_selectedArea == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, seleccione un área y una fecha.'),
            backgroundColor: Colors.red),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // CÓDIGO CORREGIDO:
    final success = await _reservationsService.createReservation(
      commonAreaId: _selectedArea!.id,
      date: _selectedDate!.toIso8601String().split('T').first, // <-- CORREGIDO
    );

    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Reserva creada con éxito'
              : 'Error al crear la reserva'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Nueva Reserva')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<CommonArea>(
              value: _selectedArea,
              items: widget.commonAreas.map((area) {
                return DropdownMenuItem(value: area, child: Text(area.name));
              }).toList(),
              onChanged: (area) => setState(() => _selectedArea = area),
              decoration: const InputDecoration(
                labelText: 'Seleccionar Área Común',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha de Reserva',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Toca para seleccionar una fecha'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReservation,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 3, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_alt_outlined),
                          SizedBox(width: 8),
                          Text('GUARDAR', style: TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
