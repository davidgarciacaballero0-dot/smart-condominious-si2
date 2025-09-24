// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package.flutter/material.dart';
import 'models/reservation_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'services/api_service.dart'; // <-- 1. Importamos el ApiService
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final CommonArea commonArea;

  const BookingPage({super.key, required this.commonArea});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ApiService _apiService =
      ApiService(); // <-- 2. Instanciamos el servicio
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  final _guestsController = TextEditingController();
  bool _isLoading = false; // Para mostrar un indicador de carga

  final List<TimeOfDay> _availableTimes = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _guestsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _guestsController.dispose();
    super.dispose();
  }

  // Lógica para determinar qué campos mostrar según el área
  bool get shouldShowGuestsField =>
      widget.commonArea.name.toLowerCase().contains('salón') ||
      widget.commonArea.name.toLowerCase().contains('churrasquera');

  bool get allowsTimeSlotSelection => !shouldShowGuestsField;

  bool get isConfirmButtonEnabled =>
      _selectedDay != null &&
      (allowsTimeSlotSelection
          ? _selectedTime != null
          : _guestsController.text.isNotEmpty);

  // --- 3. NUEVA FUNCIÓN PARA ENVIAR LA RESERVA ---
  Future<void> _submitReservation() async {
    if (!isConfirmButtonEnabled) return;

    setState(() => _isLoading = true);

    try {
      final date = DateFormat('yyyy-MM-dd').format(_selectedDay!);
      // El backend espera una hora de inicio y fin, aquí hacemos una suposición simple
      final startTime =
          _selectedTime != null ? '${_selectedTime!.hour}:00' : '09:00';
      final endTime =
          _selectedTime != null ? '${_selectedTime!.hour + 1}:00' : '17:00';

      final success = await _apiService.createReservation(
        widget.commonArea.id,
        date,
        startTime,
        endTime,
      );

      if (success && mounted) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('No se pudo crear la reserva. Inténtelo de nuevo.');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green, size: 28),
          SizedBox(width: 10),
          Text('¡Éxito!'),
        ]),
        content: const Text('Tu solicitud de reserva ha sido enviada.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Cierra el diálogo de éxito
              Navigator.of(context).pop(); // Regresa a la lista de áreas
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar ${widget.commonArea.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (El código de la UI para seleccionar fecha y hora no cambia)
            Text('1. Selecciona una fecha',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            Card(
                // ... TableCalendar
                ),

            // ... (Widgets para horario o invitados)

            const SizedBox(height: 32.0),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('CONFIRMAR RESERVA'),
                      // --- 4. Conectamos el botón a la nueva función ---
                      onPressed:
                          isConfirmButtonEnabled ? _submitReservation : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
