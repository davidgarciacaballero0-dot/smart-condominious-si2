import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class PaymentDetailPage extends StatelessWidget {
  final Payment payment;
  const PaymentDetailPage({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isPending = payment.status == PaymentStatus.pendiente ||
        payment.status == PaymentStatus.vencido;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Detalle de ${payment.type == PaymentType.expensa ? "Expensa" : "Servicio"}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(payment.concept, style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Monto: Bs. ${payment.amount.toStringAsFixed(2)}',
                style: textTheme.titleLarge),
            const Divider(height: 48),

            // ... (Aquí irían más detalles del pago)

            const Spacer(), // Empuja el botón al final de la pantalla
            if (isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text('PAGAR EN LÍNEA'),
                  onPressed: () {/* Lógica de pago futura */},
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('VER COMPROBANTE'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600),
                  onPressed: () {/* Lógica para ver comprobante */},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
