import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'login_page.dart';

// Importamos los modelos y páginas que necesitaremos para los atajos
import 'models/announcement_model.dart';
import 'models/payment_model.dart';
import 'communications_page.dart';
import 'finances_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Announcement? _latestUnreadAnnouncement;
  Payment? _nextPendingPayment;

  // Creamos datos de prueba aquí para simular la obtención de datos
  final List<Announcement> _announcements = [
    Announcement(
        id: 1, // <-- CORREGIDO: '1' a 1 (String a int)
        title: 'Mantenimiento Programado de Ascensores',
        content: 'Estimados residentes...',
        date: DateTime(2025, 9, 15),
        author: 'Administración',
        isImportant: true,
        isRead: false),
    Announcement(
        id: 2, // <-- CORREGIDO: '2' a 2 (String a int)
        title: 'Campaña de Fumigación General',
        content: 'Se llevará a cabo una campaña...',
        date: DateTime(2025, 9, 12),
        author: 'Administración',
        isRead: false),
    Announcement(
        id: 3, // <-- CORREGIDO: '3' a 3 (String a int)
        title: 'Recordatorio: Uso Adecuado de la Piscina',
        content: 'Les recordamos a todos...',
        date: DateTime(2025, 9, 10),
        author: 'Comité de Convivencia',
        isRead: true),
  ];

  final List<Payment> _payments = [
    Payment(
        id: 4, // <-- CORREGIDO: '3' a 4 (String a int, y debe ser único)
        concept: 'Expensas Octubre 2025',
        amount: 560.50,
        dueDate: DateTime(2025, 10, 10),
        status: PaymentStatus.pendiente),
    Payment(
        id: 5, // <-- CORREGIDO: '5' a 5 (String a int)
        concept: 'Expensas Julio 2025',
        amount: 540.00,
        dueDate: DateTime(2025, 7, 10),
        status: PaymentStatus.vencido),
    Payment(
        id: 6, // <-- CORREGIDO: '1' a 6 (String a int, y debe ser único)
        concept: 'Expensas Septiembre 2025',
        amount: 550.00,
        dueDate: DateTime(2025, 9, 10),
        status: PaymentStatus.pagado,
        paymentDate: DateTime(
            2025, 9, 5)), // <-- CORREGIDO: 'paymentDate' a 'payment_date'
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    setState(() {
      // Lógica para encontrar el último comunicado no leído
      final unread = _announcements.where((a) => !a.isRead).toList();
      if (unread.isNotEmpty) {
        unread.sort((a, b) => b.date.compareTo(a.date));
        _latestUnreadAnnouncement = unread.first;
      }

      // Lógica para encontrar el pago pendiente con la fecha de vencimiento más próxima
      final pending = _payments
          .where((p) =>
              p.status == PaymentStatus.pendiente ||
              p.status == PaymentStatus.vencido)
          .toList();
      if (pending.isNotEmpty) {
        pending.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        _nextPendingPayment = pending.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Menú Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SECCIÓN DE BIENVENIDA ---
            Image.asset('assets/images/welcome_logo.png', height: 180),
            const SizedBox(height: 24),
            Text('Bienvenido a Smart Condominium',
                style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                'Selecciona una opción del menú lateral o accede a tus atajos.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center),
            const Divider(height: 48),

            // --- SECCIÓN DE ATAJOS ---
            if (_latestUnreadAnnouncement != null)
              ShortcutCard(
                icon: Icons.campaign_outlined,
                title: 'Último Comunicado',
                subtitle: _latestUnreadAnnouncement!.title,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CommunicationsPage())),
              ),

            if (_nextPendingPayment != null)
              ShortcutCard(
                icon: Icons.receipt_long_outlined,
                title: 'Próximo Pago Pendiente',
                subtitle: _nextPendingPayment!.concept,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FinancesPage())),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para las nuevas tarjetas de atajo
class ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ShortcutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon,
                  size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
