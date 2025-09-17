import 'package:flutter/material.dart';
import '../models/payment_model.dart'; // <-- 1. Importamos nuestro nuevo modelo

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  // --- 2. CREAMOS NUESTRA LISTA DE DATOS DE PRUEBA ---
  final List<Payment> _payments = [
    Payment(
      id: '1',
      concept: 'Expensas Septiembre 2025',
      amount: 550.00,
      dueDate: DateTime(2025, 9, 10),
      status: PaymentStatus.pagado,
      paymentDate: DateTime(2025, 9, 5),
    ),
    Payment(
      id: '2',
      concept: 'Expensas Agosto 2025',
      amount: 550.00,
      dueDate: DateTime(2025, 8, 10),
      status: PaymentStatus.pagado,
      paymentDate: DateTime(2025, 8, 8),
    ),
    Payment(
      id: '3',
      concept: 'Expensas Octubre 2025',
      amount: 560.50,
      dueDate: DateTime(2025, 10, 10),
      status: PaymentStatus.pendiente,
    ),
    Payment(
      id: '4',
      concept: 'Expensas Julio 2025',
      amount: 540.00,
      dueDate: DateTime(2025, 7, 10),
      status: PaymentStatus.vencido,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago de Expensas'),
      ),
      // --- 3. CONSTRUIMOS LA LISTA VISUAL ---
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          final payment = _payments[index];
          // Usamos un Widget personalizado para cada elemento
          return PaymentListItem(payment: payment);
        },
      ),
    );
  }
}

// --- 4. WIDGET REUTILIZABLE PARA CADA EXPENSA ---
class PaymentListItem extends StatelessWidget {
  final Payment payment;

  const PaymentListItem({super.key, required this.payment});

  // Función para obtener el color y el ícono según el estado
  (Color, IconData) _getStatusStyle(
      PaymentStatus status, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case PaymentStatus.pagado:
        return (Colors.green.shade700, Icons.check_circle);
      case PaymentStatus.pendiente:
        return (Colors.orange.shade800, Icons.hourglass_bottom);
      case PaymentStatus.vencido:
        return (colorScheme.error, Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (statusColor, statusIcon) = _getStatusStyle(payment.status, context);
    final formattedAmount = 'Bs. ${payment.amount.toStringAsFixed(2)}';

    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viendo detalles de ${payment.concept}')),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Ícono de estado a la izquierda
              Icon(statusIcon, color: statusColor, size: 40),
              const SizedBox(width: 16.0),
              // Columna con la información del pago
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.concept,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Monto: $formattedAmount',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Vencimiento: ${payment.dueDate.day}/${payment.dueDate.month}/${payment.dueDate.year}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              // Chevron para indicar que se puede tocar
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
