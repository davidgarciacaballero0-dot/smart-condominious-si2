import 'package:flutter/material.dart';
import 'package:app/models/payment_model.dart';
import 'package:app/services/finances_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailPage extends StatefulWidget {
  final FinancialFee fee;
  const PaymentDetailPage({super.key, required this.fee});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  bool _isLoading = false;

  // *** LÓGICA DE PAGO IMPLEMENTADA ***
  Future<void> _initiatePayment() async {
    setState(() => _isLoading = true);
    try {
      final paymentUrl = await FinancesService().initiatePayment(widget.fee.id);
      final uri = Uri.parse(paymentUrl);

      if (await canLaunchUrl(uri)) {
        // Abre la URL en un navegador externo
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // Regresamos a la pantalla anterior indicando que se intentó un pago.
        if (mounted) Navigator.of(context).pop(true);
      } else {
        throw 'No se pudo abrir la URL de pago.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs. ');
    final dateFormat = DateFormat.yMMMMd('es_ES');
    final isPayable =
        ['pendiente', 'vencido'].contains(widget.fee.status.toLowerCase());

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Pago'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.fee.description,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(),
            _buildDetailRow('Monto:', currencyFormat.format(widget.fee.amount)),
            const Divider(),
            _buildDetailRow(
                'Fecha de Vencimiento:', dateFormat.format(widget.fee.dueDate)),
            const Divider(),
            _buildDetailRow('Estado:', widget.fee.status.toUpperCase(),
                color: _getStatusColor(widget.fee.status)),
            const Spacer(),

            // *** BOTÓN CONDICIONAL Y CON LÓGICA ***
            if (isPayable)
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _initiatePayment,
                      icon: const Icon(Icons.payment),
                      label: const Text('PAGAR EN LÍNEA'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange.shade800;
      case 'vencido':
        return Colors.red.shade700;
      case 'pagado':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade600;
    }
  }
}
