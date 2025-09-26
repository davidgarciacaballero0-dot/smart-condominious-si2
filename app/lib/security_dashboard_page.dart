// lib/security_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:app/visitor_history_page.dart';
import 'package:app/report_incident_page.dart';

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Seguridad')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildDashboardCard(
            context,
            icon: Icons.history,
            label: 'Historial de Visitas',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const VisitorHistoryPage())),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.report,
            label: 'Reportar Incidente',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ReportIncidentPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0),
            const SizedBox(height: 10.0),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
