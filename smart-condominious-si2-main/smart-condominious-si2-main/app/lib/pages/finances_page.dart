// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isPaying =
      false; // Variable para controlar el estado de carga del botón

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

  // --- NUEVA FUNCIÓN PARA MANEJAR EL PAGO ---
  Future<void> _handlePayment(FinancialFee fee) async {
    setState(() {
      _isPaying = true;
    });

    final checkoutUrl = await _financesService.initiatePayment(fee.id);

    if (mounted) {
      if (checkoutUrl != null) {
        final uri = Uri.parse(checkoutUrl);
        // Usamos el paquete para lanzar la URL. Abrirá el navegador del dispositivo.
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo abrir el enlace de pago.'),
                backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al generar el enlace de pago.'),
              backgroundColor: Colors.red),
        );
      }
    }

    setState(() {
      _isPaying = false;
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
            Tab(icon: Icon(Icons.history), text: 'HISTORIAL DE PAGOS'),
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
          final pendingFees =
              allFees.where((fee) => fee.status == 'Pending').toList();
          final paidFees =
              allFees.where((fee) => fee.status == 'Paid').toList();

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
              ? '¡Felicidades! No tienes cuotas pendientes.'
              : 'Aún no tienes pagos registrados.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    // El RefreshIndicator permite al usuario deslizar hacia abajo para recargar la lista
    return RefreshIndicator(
      onRefresh: () async => _loadFees(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fees.length,
        itemBuilder: (context, index) {
          final fee = fees[index];
          // Llama a la función que construye cada tarjeta individual
          return _buildFeeCard(fee, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildFeeCard(FinancialFee fee, {required bool isPending}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isPending
            ? const BorderSide(color: Colors.orange, width: 1.5)
            : BorderSide.none,
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
                    style: const TextStyle(fontSize: 16)),
                Text('Vence: ${fee.dueDate}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // --- BOTÓN DE PAGO ACTUALIZADO ---
                child: ElevatedButton.icon(
                  onPressed: _isPaying ? null : () => _handlePayment(fee),
                  icon: _isPaying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3))
                      : const Icon(Icons.payment),
                  label: Text(_isPaying ? 'GENERANDO...' : 'PAGAR AHORA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
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
