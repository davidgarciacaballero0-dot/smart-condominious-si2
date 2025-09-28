// lib/pages/reservations_page.dart
import 'package:flutter/material.dart';
import '../models/common_area_model.dart';
import '../models/reservation_model.dart';
import '../services/reservations_service.dart';
import 'add_reservation_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final _reservationsService = ReservationsService();
  Future<List<CommonArea>>? _commonAreasFuture;
  Future<List<Reservation>>? _myReservationsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _commonAreasFuture = _reservationsService.getCommonAreas();
      _myReservationsFuture = _reservationsService.getMyReservations();
    });
  }

  // --- NUEVA FUNCIÓN PARA CANCELAR ---
  Future<void> _cancelReservation(int reservationId) async {
    // Mostrar diálogo de confirmación
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Cancelación'),
        content:
            const Text('¿Estás seguro de que quieres cancelar esta reserva?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, Cancelar')),
        ],
      ),
    );

    if (confirm == true) {
      // Usamos el método del servicio para cambiar el estado a "Cancelada"
      final success = await _reservationsService.updateReservationStatus(
        reservationId: reservationId,
        newStatus: 'Cancelada',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Reserva cancelada con éxito'
              : 'Error al cancelar la reserva'),
          backgroundColor: success ? Colors.green : Colors.red,
        ));
      }

      // Si fue exitoso, refrescamos la lista
      if (success) {
        _loadData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Áreas Comunes y Reservas')),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildMyReservationsSection(),
            const SizedBox(height: 24),
            _buildCommonAreasSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final areas = await _commonAreasFuture;
          if (areas == null || !mounted) return;
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddReservationPage(commonAreas: areas)));
          if (result == true) {
            _loadData();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Reserva'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildMyReservationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mis Reservas', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        FutureBuilder<List<Reservation>>(
          future: _myReservationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError)
              return const Text('Error al cargar tus reservas.');
            final reservations = snapshot.data ?? [];
            if (reservations.isEmpty) {
              return const Card(
                  child: ListTile(
                      title: Text('No tienes ninguna reserva activa.')));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                final bool isCancellable = reservation.status == 'Pendiente' ||
                    reservation.status == 'Confirmada';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(reservation.commonAreaName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Fecha: ${reservation.reservationDate}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(reservation.status,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                          backgroundColor: _getStatusColor(reservation.status),
                        ),
                        // --- NUEVO MENÚ DE OPCIONES ---
                        if (isCancellable) // Solo muestra el menú si se puede cancelar
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'cancel') {
                                _cancelReservation(reservation.id);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'cancel',
                                child: ListTile(
                                  leading: Icon(Icons.cancel_outlined,
                                      color: Colors.red),
                                  title: Text('Cancelar Reserva'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Pequeña función para asignar color según el estado
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmada':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      case 'Pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCommonAreasSection() {
    // ... (Esta parte no necesita cambios, la dejo por completitud) ...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Áreas Disponibles',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        FutureBuilder<List<CommonArea>>(
          future: _commonAreasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError)
              return const Text('Error al cargar las áreas comunes.');
            final areas = snapshot.data ?? [];
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: areas.length,
              itemBuilder: (context, index) {
                final area = areas[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          area.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(area.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
