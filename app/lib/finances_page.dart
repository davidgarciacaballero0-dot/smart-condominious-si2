// En: app/lib/finances_page.dart (Reemplazar todo el contenido)

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
    with SingleTickerProviderStateMixin {
  final FinancesService _financesService = FinancesService();
  late Future<List<FinancialFee>> _feesFuture;
  late TabController _tabController;

  List<FinancialFee> _pendingFees = [];
  List<FinancialFee> _paidFees = [];
  double _totalPending = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAndFilterFees();
  }

  void _loadAndFilterFees() {
    _feesFuture = _financesService.getFinancialFees(); // Llama sin filtro
    _feesFuture.then((allFees) {
      if (mounted) {
        setState(() {
          // *** LÓGICA DE FILTRADO CORREGIDA ***
          // La pestaña de pendientes ahora incluye 'Pendiente' y 'Vencido'.
          _pendingFees = allFees
              .where((fee) =>
                  ['pendiente', 'vencido'].contains(fee.status.toLowerCase()))
              .toList();

          _paidFees = allFees
              .where((fee) => fee.status.toLowerCase() == 'pagado')
              .toList();

          _totalPending =
              _pendingFees.fold(0.0, (sum, item) => sum + item.amount);
        });
      }
    }).catchError((error) {
      debugPrint("Error al cargar las finanzas: $error");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _loadAndFilterFees();
    });
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
          tabs: const [
            Tab(icon: Icon(Icons.warning_amber_rounded), text: 'Pendientes'),
            Tab(icon: Icon(Icons.history), text: 'Historial'),
          ],
        ),
      ),
      body: FutureBuilder<List<FinancialFee>>(
        future: _feesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos.'));
          }

          return Column(
            children: [
              if (_tabController.index == 0 && _totalPending > 0)
                _buildTotalPendingCard(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFeesList(_pendingFees,
                        '¡Estás al día! No tienes pagos pendientes.'),
                    _buildFeesList(
                        _paidFees, 'No tienes pagos en tu historial.'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalPendingCard() {
    final formatCurrency =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.red[50],
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
            Text(formatCurrency.format(_totalPending),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900])),
          ],
        ),
      ),
    );
  }

  Widget _buildFeesList(List<FinancialFee> fees, String emptyMessage) {
    if (fees.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(emptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ));
    }
    return RefreshIndicator(
      onRefresh: () async => _refreshData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: fees.length,
        itemBuilder: (context, index) {
          return _buildFeeCard(fees[index]);
        },
      ),
    );
  }

  Widget _buildFeeCard(FinancialFee fee) {
    final formatCurrency =
        NumberFormat.currency(locale: 'es_BO', symbol: 'Bs.');
    final statusColor = _getStatusColor(fee.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(Icons.receipt_long, color: statusColor, size: 40),
        title: Text(fee.description,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle:
            Text('Vence: ${DateFormat.yMMMMd('es_ES').format(fee.dueDate)}'),
        trailing: Text(formatCurrency.format(fee.amount),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: statusColor)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentDetailPage(fee: fee)),
          ).then((paymentMade) {
            // Si regresamos de la página de detalle y un pago se realizó, actualizamos la lista.
            if (paymentMade == true) {
              _refreshData();
            }
          });
        },
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
