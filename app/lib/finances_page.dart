// app/lib/finances_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/payment_model.dart';
import 'package:app/services/finances_service.dart';
import 'package:app/payment_detail_page.dart';
import 'package:intl/intl.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.error_outline), text: 'Pagos Pendientes'),
            Tab(icon: Icon(Icons.history), text: 'Historial de Pagos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          FinancialFeesList(status: 'Pending'),
          FinancialFeesList(status: 'Paid'),
        ],
      ),
    );
  }
}

class FinancialFeesList extends StatefulWidget {
  final String status;
  const FinancialFeesList({super.key, required this.status});

  @override
  State<FinancialFeesList> createState() => _FinancialFeesListState();
}

class _FinancialFeesListState extends State<FinancialFeesList> {
  final FinancesService _financesService = FinancesService();
  late Future<List<FinancialFee>> _futureFees;

  @override
  void initState() {
    super.initState();
    _futureFees = _financesService.getFinancialFees(status: widget.status);
  }

  Widget _buildSummaryCard(double totalAmount) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    return Card(
      color: Colors.red[50],
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.red.shade200, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Pendiente:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800])),
            Text(currencyFormat.format(totalAmount),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900])),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FinancialFee>>(
      future: _futureFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                widget.status == 'Pending'
                    ? '¡Estás al día! No tienes pagos pendientes.'
                    : 'No hay pagos en tu historial.',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          final fees = snapshot.data!;
          double totalPending = 0;
          if (widget.status == 'Pending') {
            totalPending = fees.fold(0.0, (sum, item) => sum + item.amount);
          }

          return Column(
            children: [
              if (widget.status == 'Pending' && totalPending > 0)
                _buildSummaryCard(totalPending),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  itemCount: fees.length,
                  itemBuilder: (context, index) => _buildFeeCard(fees[index]),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildFeeCard(FinancialFee fee) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    final dateFormat = DateFormat('d MMM, yyyy', 'es').format(fee.dueDate);
    final isPending = fee.status.toLowerCase() == 'pending' ||
        fee.status.toLowerCase() ==
            'overdue'; // Considerar también "Overdue" como pendiente para el botón

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentDetailPage(fee: fee))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fee.description,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vencimiento: $dateFormat',
                      style: const TextStyle(color: Colors.grey)),
                  Text(
                    currencyFormat.format(fee.amount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      // Color rojo para pendiente/vencido, verde para pagado
                      color: (fee.status.toLowerCase() == 'pending' ||
                              fee.status.toLowerCase() == 'overdue')
                          ? Colors.redAccent
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              if (isPending) ...[
                // Muestra el botón solo si está pendiente o vencido
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Simplemente navegamos al detalle, donde estará el botón "Pagar en Línea"
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PaymentDetailPage(fee: fee)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text('Pagar Ahora',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
