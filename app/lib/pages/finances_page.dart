// lib/pages/finances_page.dart
import 'package:flutter/material.dart';
import '../models/financial_fee_model.dart';
import '../services/finances_service.dart';
              
class FinancesPage extends StatefulWidget {
  const FinancesPage({Key? key}) : super(key: key);
  @override
  _FinancesPageState createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage>
    with SingleTickerProviderStateMixin {
  final _financesService = FinancesService();
  Future<List<FinancialFee>>? _feesFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFees();
  }

  void _loadFees() {
    setState(() {
      _feesFuture = _financesService.getMyFinancialFees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.warning_amber_rounded), text: 'PENDIENTES'),
            Tab(
                icon: Icon(Icons.history),
                text: 'HISTORIAL DE PAGOS'), // <-- TEXTO E ICONO CAMBIADOS
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
            return const Center(
                child: Text('Error al cargar los datos financieros.'));
          }
          final allFees = snapshot.data ?? [];
          // CORRECCIÓN: Ahora también incluimos las vencidas como pendientes
          final pendingFees = allFees
              .where(
                  (fee) => fee.status == 'Pendiente' || fee.status == 'Vencido')
              .toList();
          final paidFees =
              allFees.where((fee) => fee.status == 'Pagado').toList();
          return TabBarView(
            controller: _tabController,
            children: [
              _buildFeesList(pendingFees, isPending: true),
              _buildFeesList(paidFees, isPending: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeesList(List<FinancialFee> fees, {required bool isPending}) {
    // ... (El código de esta función no cambia)
    if (fees.isEmpty) {
      return Center(
          child: Text(
              isPending
                  ? 'No tienes cuotas pendientes.'
                  : 'No tienes pagos registrados.',
              style: const TextStyle(fontSize: 16, color: Colors.grey)));
    }
    return RefreshIndicator(
      onRefresh: () async => _loadFees(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fees.length,
        itemBuilder: (context, index) {
          final fee = fees[index];
          return _buildFeeCard(fee, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildFeeCard(FinancialFee fee, {required bool isPending}) {
    // ... (El código de esta función no cambia)
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isPending
            ? BorderSide(
                color: fee.status == 'Vencido' ? Colors.red : Colors.orange,
                width: 1.5)
            : const BorderSide(color: Colors.green, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fee.description,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Monto: \$${fee.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text('Vence: ${fee.dueDate}',
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      print('Iniciar pago para la cuota ID: ${fee.id}'),
                  icon: const Icon(Icons.payment),
                  label: const Text('PAGAR AHORA'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
