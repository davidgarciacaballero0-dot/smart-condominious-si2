// app/lib/reservations_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/reservation_model.dart';
import 'package:app/services/reservations_service.dart';
import 'package:intl/intl.dart';
import 'package:app/add_reservation_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final ReservationsService _reservationsService = ReservationsService();
  late Future<List<Reservation>> _futureReservations;

  @override
  void initState() {
    super.initState();
    _futureReservations = _reservationsService.getReservations();
  }

  void _navigateAndRefresh() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddReservationPage()),
    );

    if (result == true && mounted) {
      setState(() {
        _futureReservations = _reservationsService.getReservations();
      });
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
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí, Cancelar')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _reservationsService.cancelReservation(reservationId);
        setState(() {
          _futureReservations = _reservationsService.getReservations();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Reserva cancelada con éxito'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: _futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes reservas registradas.'));
          } else {
            final reservations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return _buildReservationCard(reservations[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndRefresh,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    // --- LÍNEA CORREGIDA ---
    // Primero verificamos si la fecha es nula.
    final String formattedDate = reservation.date != null
        ? DateFormat('d \'de\' MMMM, yyyy', 'es').format(reservation.date!)
        : 'Fecha no especificada';

    final statusInfo = _getStatusInfo(reservation.status);
    final canCancel =
        ['approved', 'pending'].contains(reservation.status.toLowerCase());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        leading: Icon(statusInfo['icon'], color: statusInfo['color'], size: 40),
        title: Text(
          reservation.commonAreaName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Fecha: $formattedDate\nHora: ${reservation.timeSlot}',
        ),
        trailing: canCancel
            ? TextButton(
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.redAccent)),
                onPressed: () => _cancelReservation(reservation.id),
              )
            : Text(
                reservation.status.toUpperCase(),
                style: TextStyle(
                  color: statusInfo['color'],
                  fontWeight: FontWeight.bold,
                ),
              ),
        isThreeLine: true,
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return {'color': Colors.green, 'icon': Icons.check_circle};
      case 'pending':
        return {'color': Colors.orange, 'icon': Icons.hourglass_top};
      case 'rejected':
      case 'cancelled':
        return {'color': Colors.red, 'icon': Icons.cancel};
      default:
        return {'color': Colors.grey, 'icon': Icons.help_outline};
    }
  }
}
