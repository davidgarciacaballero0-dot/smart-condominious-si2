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
    // Este controlador manejará las 2 pestañas (Pendientes, Pagadas)
    _tabController = TabController(length: 2, vsync: this);
    _loadFees();
  }

  // Método para cargar o recargar los datos desde el backend
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
        // Aquí definimos las pestañas que irán debajo del título
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.warning_amber_rounded), text: 'PENDIENTES'),
            Tab(icon: Icon(Icons.check_circle_outline), text: 'PAGADAS'),
          ],
        ),
      ),
      body: FutureBuilder<List<FinancialFee>>(
        future: _feesFuture,
        builder: (context, snapshot) {
          // Mientras los datos están cargando, muestra un spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si hubo un error, muestra un mensaje
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar los datos financieros.'));
          }
          final allFees = snapshot.data ?? [];

          // Filtramos la lista completa en dos listas más pequeñas
          final pendingFees =
              allFees.where((fee) => fee.status == 'Pending').toList();
          final paidFees =
              allFees.where((fee) => fee.status == 'Paid').toList();

          // El TabBarView muestra el contenido de cada pestaña
          return TabBarView(
            controller: _tabController,
            children: [
              // Contenido de la primera pestaña (Pendientes)
              _buildFeesList(pendingFees, isPending: true),
              // Contenido de la segunda pestaña (Pagadas)
              _buildFeesList(paidFees, isPending: false),
            ],
          );
        },
      ),
    );
  }

  // Widget que se encarga de construir la lista de tarjetas
  Widget _buildFeesList(List<FinancialFee> fees, {required bool isPending}) {
    if (fees.isEmpty) {
      return Center(
        child: Text(
          isPending
              ? '¡Felicidades! No tienes cuotas pendientes.'
              : 'Aún no tienes pagos registrados.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    // RefreshIndicator permite deslizar hacia abajo para recargar la lista
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

  // Widget que construye el diseño de cada tarjeta individual
  Widget _buildFeeCard(FinancialFee fee, {required bool isPending}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isPending
            ? const BorderSide(color: Colors.orange, width: 1.5)
            : const BorderSide(color: Colors.green, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fee.description,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monto: \$${fee.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Vence: ${fee.dueDate}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            // Si la cuota está pendiente, muestra el botón de "PAGAR AHORA"
            if (isPending) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    print('Iniciar pago para la cuota ID: ${fee.id}');
                    // Aquí se puede agregar la navegación a una pasarela de pago
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('PAGAR AHORA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
