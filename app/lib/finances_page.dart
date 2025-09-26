// app/lib/finances_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/payment_model.dart';
import 'package:app/services/finances_service.dart';
import 'package:intl/intl.dart';
import 'package:app/payment_detail_page.dart'; // <-- AÑADE ESTA IMPORTACIÓN

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  final FinancesService _financesService = FinancesService();
  late Future<List<FinancialFee>> _futureFinancialFees;

  @override
  void initState() {
    super.initState();
    _futureFinancialFees = _financesService.getFinancialFees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
      ),
      body: FutureBuilder<List<FinancialFee>>(
        future: _futureFinancialFees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros financieros.'));
          } else {
            final fees = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: fees.length,
              itemBuilder: (context, index) {
                return _buildFeeCard(fees[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildFeeCard(FinancialFee fee) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    final dateFormat = DateFormat('d MMMM, yyyy', 'es');
    final statusColor =
        fee.status.toLowerCase() == 'paid' ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: statusColor, size: 40),
        title: Text(fee.description,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Vence: ${dateFormat.format(fee.dueDate)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(fee.amount),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              fee.status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // AÑADE ESTA LÍNEA PARA HACER LA TARJETA INTERACTIVA:
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentDetailPage(fee: fee)),
          );
        },
      ),
    );
  }
}
