// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/announcement_model.dart';
import '../models/financial_fee_model.dart';
import '../services/announcement_services.dart';
import '../services/auth_provider.dart';
import '../services/finances_service.dart';
import '../widgets/app_drawer.dart';
import 'communications_page.dart';
import 'finances_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<FinancialFee?>? _nextFeeFuture;
  Future<Announcement?>? _latestAnnouncementFuture;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    setState(() {
      _nextFeeFuture = FinancesService().getMyFinancialFees().then((fees) {
        final pending = fees
            .where((f) => f.status == 'Pendiente' || f.status == 'Vencido')
            .toList();
        pending.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        return pending.isNotEmpty ? pending.first : null;
      });

      _latestAnnouncementFuture =
          AnnouncementsService().getAnnouncements().then((ann) {
        return ann.isNotEmpty ? ann.first : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Image.asset('assets/images/logo_main.png', height: 40),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadDashboardData(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text('Bienvenido,', style: Theme.of(context).textTheme.titleLarge),
            Text(user?.fullName ?? 'Usuario',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildNextPaymentCard(),
            const SizedBox(height: 16),
            _buildLatestAnnouncementCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPaymentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<FinancialFee?>(
          future: _nextFeeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final fee = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Próximo Pago Pendiente',
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(height: 20),
                if (fee != null) ...[
                  Text(fee.description,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Monto: \$${fee.amount.toStringAsFixed(2)}'),
                  Text('Vence: ${fee.dueDate}'),
                ] else
                  const Text('¡No tienes pagos pendientes!'),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const FinancesPage())),
                    child: const Text('VER TODOS MIS PAGOS'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLatestAnnouncementCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Announcement?>(
          future: _latestAnnouncementFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final announcement = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Último Comunicado',
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(height: 20),
                if (announcement != null) ...[
                  Text(announcement.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(announcement.content,
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                ] else
                  const Text('No hay comunicados recientes.'),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const CommunicationsPage())),
                    child: const Text('VER TODOS LOS COMUNICADOS'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
