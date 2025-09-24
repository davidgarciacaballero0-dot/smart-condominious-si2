import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'models/payment_model.dart';
import 'payment_detail_page.dart';
import 'package:intl/intl.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  Future<List<Payment>>? _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Iniciamos la carga de datos
    _paymentsFuture = _apiService.getFinancialFees();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.hourglass_empty_rounded, size: 20),
              SizedBox(width: 8),
              Text('Pendientes')
            ])),
            Tab(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.history_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Historial')
                ])),
          ],
        ),
      ),
      body: FutureBuilder<List<Payment>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          // Mientras carga, muestra un spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si hay un error, muestra un mensaje
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar los datos: ${snapshot.error}'));
          }
          // Si no hay datos, muestra un mensaje
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No se encontraron registros de pago.'));
          }

          // Si todo está bien, filtramos y mostramos los datos
          final allPayments = snapshot.data!;
          final pendingPayments = allPayments
              .where((p) =>
                  p.status == PaymentStatus.pendiente ||
                  p.status == PaymentStatus.vencido)
              .toList();
          final paidPayments = allPayments
              .where((p) => p.status == PaymentStatus.pagado)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              PaymentListView(payments: pendingPayments),
              PaymentListView(payments: paidPayments),
            ],
          );
        },
      ),
    );
  }
}

// Los widgets PaymentListView y PaymentListItem no necesitan grandes cambios,
// solo asegúrate de que usan el modelo actualizado (id como int, etc.).
class PaymentListView extends StatelessWidget {
  final List<Payment> payments;
  const PaymentListView({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('No hay pagos en esta sección.',
                  textAlign: TextAlign.center)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        return PaymentListItem(payment: payments[index]);
      },
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final Payment payment;
  const PaymentListItem({super.key, required this.payment});

  (Color, IconData) _getStatusStyle(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pagado:
        return (Colors.green, Icons.check_circle);
      case PaymentStatus.pendiente:
        return (Colors.orange, Icons.pending);
      case PaymentStatus.vencido:
        return (Colors.red, Icons.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusIcon) = _getStatusStyle(payment.status);
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
                  builder: (context) => PaymentDetailPage(payment: payment)));
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
                    Text(payment.concept,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: isPending
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                    const SizedBox(height: 4.0),
                    Text('Monto: Bs. ${payment.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 4.0),
                    Text(
                        'Vence: ${DateFormat('dd/MM/yyyy').format(payment.dueDate)}',
                        style: Theme.of(context).textTheme.bodyMedium),
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
