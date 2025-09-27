// En: app/lib/add_reservation_page.dart (Archivo existente)
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:app/models/common_area_model.dart';
import 'package:app/services/reservations_service.dart';
import 'package:intl/intl.dart';

class AddReservationPage extends StatefulWidget {
  final CommonArea? commonArea;

  const AddReservationPage({super.key, this.commonArea});

  @override
  State<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final ReservationsService _reservationsService = ReservationsService();

  List<CommonArea> _commonAreas = [];
  CommonArea? _selectedArea;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '09:00-11:00',
    '11:00-13:00',
    '14:00-16:00',
    '16:00-18:00',
    '19:00-21:00',
  ];

  final TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.commonArea != null) {
      _selectedArea = widget.commonArea;
    }
    _fetchCommonAreas();
  }

  // *** FUNCIÓN CORREGIDA ***
  Future<void> _fetchCommonAreas() async {
    try {
      final areas = await _reservationsService.getCommonAreas();
      if (!mounted) return;

      setState(() {
        _commonAreas = areas;
        if (widget.commonArea != null) {
          // Usamos try-catch para manejar el caso en que el área no se encuentre en la lista
          try {
            _selectedArea =
                _commonAreas.firstWhere((a) => a.id == widget.commonArea!.id);
          } catch (e) {
            // Si firstWhere falla (no encuentra nada), no hacemos nada y _selectedArea mantiene su valor inicial.
            debugPrint(
                "Área preseleccionada no encontrada en la lista, el usuario deberá seleccionarla manualmente.");
          }
        }
      });
    } catch (e) {
      debugPrint("Error al cargar áreas comunes: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _reservationsService.createReservation(
          commonAreaId: _selectedArea!.id,
          date: _dateController.text,
          timeSlot: _selectedTimeSlot!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Reserva creada con éxito'),
                backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al crear la reserva: $e'),
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
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Reserva'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<CommonArea>(
                value: _selectedArea,
                items: _commonAreas.map((area) {
                  return DropdownMenuItem<CommonArea>(
                    value: area,
                    child: Text(area.name),
                  );
                }).toList(),
                onChanged: (CommonArea? newValue) {
                  setState(() {
                    _selectedArea = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Área Común',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value == null ? 'Por favor, selecciona un área' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Reserva',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, selecciona una fecha'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                items: _timeSlots.map((slot) {
                  return DropdownMenuItem<String>(
                    value: slot,
                    child: Text(slot),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeSlot = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Horario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time_filled),
                ),
                validator: (value) =>
                    value == null ? 'Por favor, selecciona un horario' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submitReservation,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('CONFIRMAR RESERVA'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
