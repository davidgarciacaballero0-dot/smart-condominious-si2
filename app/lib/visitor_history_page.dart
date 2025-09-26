// lib/visitor_history_page.dart

import 'package:app/models/Visitor_Log_Page.dart';
import 'package:flutter/material.dart';
import 'package:app/models/visitor_log_model.dart';
import 'package:app/services/security_service.dart';
import 'package:app/visitor_log_page.dart';
import 'package:intl/intl.dart';

class VisitorHistoryPage extends StatefulWidget {
  const VisitorHistoryPage({super.key});

  @override
  State<VisitorHistoryPage> createState() => _VisitorHistoryPageState();
}

class _VisitorHistoryPageState extends State<VisitorHistoryPage> {
  final SecurityService _securityService = SecurityService();
  late Future<List<VisitorLog>> _futureLogs;

  @override
  void initState() {
    super.initState();
    _futureLogs = _securityService.getVisitorLogs();
  }

  void _navigateAndRefresh() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VisitorLogPage()),
    );
    if (result == true && mounted) {
      setState(() {
        _futureLogs = _securityService.getVisitorLogs();
      });
    }
  }

  Future<void> _registerExit(int logId) async {
    try {
      await _securityService.registerVisitorExit(logId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Salida registrada con éxito'),
            backgroundColor: Colors.green));
        setState(() {
          _futureLogs = _securityService.getVisitorLogs();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Visitas')),
      body: FutureBuilder<List<VisitorLog>>(
        future: _futureLogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros de visitas.'));
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) => _buildLogCard(logs[index]),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndRefresh,
        child: const Icon(Icons.person_add),
        tooltip: 'Registrar Entrada',
      ),
    );
  }

  Widget _buildLogCard(VisitorLog log) {
    final dateFormat = DateFormat('dd/MM/yy HH:mm');
    final bool canExit = log.status.toLowerCase() == 'inside';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(log.visitorFullName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            'Visita a: ${log.residentName}\nEntrada: ${dateFormat.format(log.entryDatetime)}'),
        trailing: canExit
            ? ElevatedButton(
                child: const Text('Registrar Salida'),
                onPressed: () => _registerExit(log.id))
            : Text(log.status.toUpperCase(),
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
