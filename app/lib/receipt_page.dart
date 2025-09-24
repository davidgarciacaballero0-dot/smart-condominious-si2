import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/payment_model.dart'; // Asegúrate de que este modelo esté actualizado

class ReceiptPage extends StatelessWidget {
  final Payment payment;

  const ReceiptPage({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    // Usamos el modelo Payment que ya tienes
    // Nota: El backend no provee una fecha de pago, así que usaremos la fecha de vencimiento como simulación
    final paymentDate =
        DateTime.now(); // Simulación de la fecha en que se ve el recibo

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprobante de Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child:
                      Icon(Icons.check_circle, color: Colors.green, size: 60),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'PAGO REALIZADO CON ÉXITO',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                const Divider(height: 48),
                _buildDetailRow('Concepto:', payment.concept),
                _buildDetailRow('Monto Pagado:',
                    'Bs. ${payment.amount.toStringAsFixed(2)}'),
                _buildDetailRow('Fecha de Emisión:',
                    DateFormat('dd/MM/yyyy HH:mm').format(paymentDate)),
                _buildDetailRow('Método de Pago:', 'Simulación Online'),
                const Spacer(),
                Center(
                  child: Text(
                    'Gracias por su pago.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
