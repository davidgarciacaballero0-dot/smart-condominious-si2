// ignore_for_file: undefined_shown_name

import 'package:app/services/api_service.dart' show getCommonAreas;
import 'package:flutter/material.dart';
import 'models/reservation_model.dart';
import 'booking_page.dart';
import 'services/api_service.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final ApiService _apiService = ApiService();
  late Future<List<CommonArea>> _commonAreasFuture;

  @override
  void initState() {
    super.initState();
    _commonAreasFuture = _apiService.getCommonAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Áreas Comunes'),
      ),
      body: FutureBuilder<List<CommonArea>>(
        future: _commonAreasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay áreas comunes disponibles.'));
          }

          final areas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: areas.length,
            itemBuilder: (context, index) {
              return CommonAreaCard(commonArea: areas[index]);
            },
          );
        },
      ),
    );
  }
}

// La clase CommonAreaCard no necesita cambios
class CommonAreaCard extends StatelessWidget {
  final CommonArea commonArea;

  const CommonAreaCard({super.key, required this.commonArea});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(commonArea: commonArea),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              commonArea.imagePath,
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(commonArea.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text(commonArea.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
