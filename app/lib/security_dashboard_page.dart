// --- SECCIÓN DE IMPORTACIONES COMPLETAS ---
import 'package:app/ai_alerts_page.dart';
import 'package:app/data/mock_data.dart';
import 'package:app/incident_history_page.dart';
import 'package:app/quick_action_button.dart';
import 'package:app/report_incident_page.dart';
import 'package:app/visitor_exit_page.dart';
import 'package:flutter/material.dart';
import 'package:app/login_page.dart';
import 'package:app/visitor_log_page.dart';
import 'package:app/visitor_history_page.dart';

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculamos los datos para el panel de estado
    final currentVisitorsCount =
        mockVisitorLogs.where((log) => log.exitTime == null).length;
    final newAlertsCount = mockAiAlerts.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Seguridad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      drawer: const SecurityDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                QuickActionButton(
                  title: 'Registrar\nEntrada',
                  icon: Icons.person_add_alt_1,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VisitorLogPage()));
                  },
                ),
                const SizedBox(width: 16),
                QuickActionButton(
                  title: 'Registrar\nSalida',
                  icon: Icons.logout,
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VisitorExitPage()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Estado Actual',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusColumn(
                        context, '$currentVisitorsCount', 'Visitantes Dentro'),
                    _buildStatusColumn(
                        context, '$newAlertsCount', 'Alertas Nuevas',
                        isAlert: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Atajos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (mockAiAlerts.isNotEmpty)
              _buildShortcutTile(
                context,
                icon: Icons.notifications_active,
                iconColor: Colors.red,
                title: 'Última Alerta IA',
                subtitle: mockAiAlerts.last.title,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AiAlertsPage()),
                  );
                },
              ),
            if (mockIncidents.isNotEmpty)
              _buildShortcutTile(
                context,
                icon: Icons.report,
                iconColor: Colors.orange,
                title: 'Último Incidente Reportado',
                subtitle: mockIncidents.last.title,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IncidentHistoryPage()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusColumn(BuildContext context, String value, String label,
      {bool isAlert = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isAlert ? Colors.red : Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildShortcutTile(BuildContext context,
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class SecurityDrawer extends StatelessWidget {
  const SecurityDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Carlos Rojas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text('Personal de Seguridad'),
            currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.security_outlined, size: 50)),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text('Gestión de Visitas',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.view_list_outlined),
            title: const Text('Historial de Visitas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VisitorHistoryPage()),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text('Gestión de Incidentes',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.report_problem_outlined),
            title: const Text('Reportar Incidente'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportIncidentPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text('Historial de Incidentes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IncidentHistoryPage()),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text('Vigilancia',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Revisar Alertas de IA'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiAlertsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_outdoor_outlined),
            title: const Text('Ver Cámaras'),
            onTap: () {
              // Lógica futura
            },
          ),
        ],
      ),
    );
  }
}
