// En: app/lib/reservations_page.dart (Reemplazar todo el contenido)

import 'package:flutter/material.dart';
import 'package:app/models/reservation_model.dart';
import 'package:app/services/reservations_service.dart';
import 'package:app/explore_areas_page.dart';
import 'package:intl/intl.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final ReservationsService _reservationsService = ReservationsService();
  late Future<List<Reservation>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() {
    setState(() {
      _reservationsFuture = _reservationsService.getReservations();
    });
  }

  Future<void> _navigateAndRefresh() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExploreAreasPage()),
    );

    if (result == true && mounted) {
      _loadReservations();
    }
  }

  Future<void> _cancelReservation(int reservationId) async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Cancelación'),
        content:
            const Text('¿Estás seguro de que deseas cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _reservationsService.cancelReservation(reservationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Reserva cancelada con éxito'),
                backgroundColor: Colors.green),
          );
          _loadReservations();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al cancelar: $e'),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadReservations(),
        child: FutureBuilder<List<Reservation>>(
          future: _reservationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child:
                      Text('Error al cargar las reservas: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No tienes reservas activas.\n¡Crea una usando el botón +!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              );
            }

            final reservations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return _buildReservationCard(reservations[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndRefresh,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    final dateFormat = DateFormat.yMMMMd('es_ES');

    // ----- ESTA ES LA CORRECCIÓN CLAVE -----
    // Antes de formatear, nos aseguramos de que la fecha no sea nula.
    final String formattedDate = reservation.date != null
        ? dateFormat.format(reservation.date!) // Si existe, la formateamos.
        : 'Fecha no disponible'; // Si no existe, usamos este texto.

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reservation.commonAreaName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            _buildInfoRow(Icons.calendar_today, 'Fecha:', formattedDate),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, 'Horario:', reservation.timeSlot),
            const SizedBox(height: 8),
            _buildInfoRow(
              _getStatusIcon(reservation.status),
              'Estado:',
              reservation.status.toUpperCase(),
              statusColor: _getStatusColor(reservation.status),
            ),
            const SizedBox(height: 12),
            if (reservation.status.toLowerCase() == 'activa')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _cancelReservation(reservation.id),
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  label: const Text('Cancelar',
                      style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: statusColor ?? Colors.grey[700]),
        const SizedBox(width: 12),
        Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: statusColor ?? Colors.black87,
                fontWeight:
                    statusColor != null ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activa':
        return Colors.green.shade700;
      case 'cancelada':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'activa':
        return Icons.check_circle;
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }
}
