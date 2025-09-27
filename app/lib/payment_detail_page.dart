// app/lib/payment_detail_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/payment_model.dart';
import 'package:intl/intl.dart';

class PaymentDetailPage extends StatelessWidget {
  final FinancialFee fee;
  const PaymentDetailPage({super.key, required this.fee});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    final dateFormat =
        DateFormat('d MMMM, yyyy', 'es'); // Formato de fecha para el detalle

    return Scaffold(
      appBar: AppBar(
        title: Text(fee.description),
        // --- Cambios visuales para la AppBar (título blanco, flecha blanca) ---
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fee.description,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildDetailRow('Monto:', currencyFormat.format(fee.amount)),
            const Divider(),
            // Manejamos la fecha de vencimiento que ahora es obligatoria
            _buildDetailRow(
                'Fecha de Vencimiento:', dateFormat.format(fee.dueDate)),
            const Divider(),
            _buildDetailRow('Estado:', fee.status.toUpperCase(),
                color: _getStatusColor(fee.status)),
            const Spacer(), // Empuja el botón al final
            // --- BOTÓN "PAGAR EN LÍNEA" AÑADIDO ---
            if (fee.status.toLowerCase() == 'pending' ||
                fee.status.toLowerCase() == 'overdue')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implementar lógica de pago en línea
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('PAGAR EN LÍNEA',
                      style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Color principal de la app
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
