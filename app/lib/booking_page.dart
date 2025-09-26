import 'package:app/models/common_area_model.dart';
import 'package:flutter/material.dart';
import 'models/reservation_model.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  final CommonArea commonArea;

  const BookingPage({super.key, required this.commonArea});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  final _guestsController = TextEditingController();

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
    // Agregamos un listener para redibujar la pantalla cuando el texto cambie
    _guestsController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _guestsController.dispose();
    super.dispose();
  }

  bool get shouldShowGuestsField =>
      widget.commonArea.name == 'Salón de Eventos' ||
      widget.commonArea.name == 'Churrasquera';

  bool get allowsTimeSlotSelection => !shouldShowGuestsField;

  // --- LÓGICA DEL BOTÓN ACTUALIZADA ---
  bool get isConfirmButtonEnabled {
    if (allowsTimeSlotSelection) {
      // Para áreas como Piscina, se necesita fecha Y hora
      return _selectedDay != null && _selectedTime != null;
    } else {
      // Para Salón/Churrasquera, se necesita fecha Y que el campo de invitados no esté vacío
      return _selectedDay != null && _guestsController.text.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar ${widget.commonArea.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Selecciona una fecha',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  locale: 'es_ES',
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 60)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: colorScheme.secondary.withAlpha(128),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            if (allowsTimeSlotSelection) ...[
              Text(
                '2. Selecciona un horario',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _availableTimes.map((time) {
                  final isSelected = _selectedTime == time;
                  return ChoiceChip(
                    label: Text(time.format(context)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTime = selected ? time : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24.0),
            ],
            if (shouldShowGuestsField) ...[
              Text(
                '2. Número de invitados',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _guestsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de invitados',
                  prefixIcon: Icon(Icons.group_outlined),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('CONFIRMAR RESERVA'),
                onPressed: isConfirmButtonEnabled
                    ? () {
                        String confirmationContent =
                            '¿Deseas reservar "${widget.commonArea.name}" para el día ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}?';

                        if (_selectedTime != null) {
                          confirmationContent =
                              '¿Deseas reservar "${widget.commonArea.name}" el día ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year} a las ${_selectedTime!.format(context)}?';
                        }

                        if (shouldShowGuestsField &&
                            _guestsController.text.isNotEmpty) {
                          confirmationContent +=
                              '\n\nNúmero de invitados: ${_guestsController.text}';
                        }

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Reserva'),
                            content: Text(confirmationContent),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Row(children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 28),
                                        SizedBox(width: 10),
                                        Text('¡Éxito!'),
                                      ]),
                                      content: const Text(
                                          'Tu solicitud de reserva ha sido enviada.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
