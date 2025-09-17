import 'package:flutter/material.dart';
import 'models/payment_model.dart';
import 'payment_detail_page.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Payment> _payments = [
    Payment(
        id: '1',
        concept: 'Expensas Septiembre 2025',
        amount: 550.00,
        dueDate: DateTime(2025, 9, 10),
        status: PaymentStatus.pagado,
        paymentDate: DateTime(2025, 9, 5),
        type: PaymentType.expensa),
    Payment(
        id: '2',
        concept: 'Expensas Agosto 2025',
        amount: 550.00,
        dueDate: DateTime(2025, 8, 10),
        status: PaymentStatus.pagado,
        paymentDate: DateTime(2025, 8, 8),
        type: PaymentType.expensa),
    Payment(
        id: '3',
        concept: 'Expensas Octubre 2025',
        amount: 560.50,
        dueDate: DateTime(2025, 10, 10),
        status: PaymentStatus.pendiente,
        type: PaymentType.expensa),
    Payment(
        id: '4',
        concept: 'Reserva Salón de Eventos',
        amount: 200.00,
        dueDate: DateTime(2025, 10, 15),
        status: PaymentStatus.pendiente,
        type: PaymentType.servicio),
    Payment(
        id: '5',
        concept: 'Expensas Julio 2025',
        amount: 540.00,
        dueDate: DateTime(2025, 7, 10),
        status: PaymentStatus.vencido,
        type: PaymentType.expensa),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingPayments = _payments
        .where((p) =>
            p.status == PaymentStatus.pendiente ||
            p.status == PaymentStatus.vencido)
        .toList();
    final paidPayments =
        _payments.where((p) => p.status == PaymentStatus.pagado).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
        // --- SECCIÓN DE PESTAÑAS CON NUEVOS COLORES ---
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors
              .white, // Color del texto e ícono de la pestaña seleccionada
          unselectedLabelColor:
              Colors.white70, // Color de la pestaña no seleccionada
          indicatorColor: Colors.white, // Color de la línea indicadora de abajo
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Pagos Pendientes'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Historial de Pagos'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PaymentListView(payments: pendingPayments, isPendingList: true),
          PaymentListView(payments: paidPayments, isPendingList: false),
        ],
      ),
    );
  }
}

class PaymentListView extends StatelessWidget {
  final List<Payment> payments;
  final bool isPendingList;
  const PaymentListView(
      {super.key, required this.payments, this.isPendingList = false});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            isPendingList
                ? '¡Felicidades! No tienes pagos pendientes.'
                : 'Aún no se han registrado pagos.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return PaymentListItem(payment: payment);
      },
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final Payment payment;
  const PaymentListItem({super.key, required this.payment});

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
    final isPending = payment.status != PaymentStatus.pagado;

    return Card(
      elevation: isPending ? 4 : 1,
      shape: RoundedRectangleBorder(
        side: isPending
            ? BorderSide(color: statusColor, width: 1.5)
            : BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentDetailPage(payment: payment),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 40),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.concept,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isPending ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Monto: Bs. ${payment.amount.toStringAsFixed(2)}',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Vence: ${payment.dueDate.day}/${payment.dueDate.month}/${payment.dueDate.year}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
