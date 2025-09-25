import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import 'receipt_page.dart'; // <-- 1. IMPORTAMOS LA NUEVA PÁGINA

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
        title: const Text('Detalle de Pago'),
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

            // Más detalles podrían ir aquí...

            const Spacer(),
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
                  // --- 2. CONECTAMOS LA NAVEGACIÓN ---
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptPage(payment: payment),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
