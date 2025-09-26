// app/lib/payment_detail_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/payment_model.dart'; // Usa el modelo FinancialFee
import 'package:intl/intl.dart';

class PaymentDetailPage extends StatelessWidget {
  final FinancialFee fee;

  const PaymentDetailPage({super.key, required this.fee});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    final dateFormat = DateFormat('d MMMM, yyyy', 'es');
    final statusColor =
        fee.status.toLowerCase() == 'paid' ? Colors.green : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: Text(fee.description),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                'Monto:', currencyFormat.format(fee.amount), context),
            const Divider(),
            _buildDetailRow('Fecha de Vencimiento:',
                dateFormat.format(fee.dueDate), context),
            const Divider(),
            _buildDetailRow(
              'Estado:',
              fee.status.toUpperCase(),
              context,
              valueColor: statusColor,
            ),
            // Puedes añadir más detalles aquí
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, BuildContext context,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
          ),
        ],
      ),
    );
  }
}
