// lib/pages/visitor_history_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/visitor_log_model.dart';
import '../services/security_service.dart';

class VisitorHistoryPage extends StatefulWidget {
  const VisitorHistoryPage({Key? key}) : super(key: key);

  @override
  _VisitorHistoryPageState createState() => _VisitorHistoryPageState();
}

class _VisitorHistoryPageState extends State<VisitorHistoryPage> {
  final _securityService = SecurityService();
  Future<List<VisitorLog>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _securityService.getVisitorHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Visitas'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadHistory(),
        child: FutureBuilder<List<VisitorLog>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar el historial.'));
            }
            final visitors = snapshot.data ?? [];
            if (visitors.isEmpty) {
              return const Center(child: Text('No hay registros de visitas.'));
            }
            return ListView.builder(
              itemCount: visitors.length,
              itemBuilder: (context, index) {
                final visitor = visitors[index];
                return _buildHistoryCard(visitor);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(VisitorLog visitor) {
    final entryTime = DateTime.parse(visitor.entryTime).toLocal();
    final formattedEntry = DateFormat('dd/MM/yy HH:mm').format(entryTime);
    final exitTime = visitor.exitTime != null ? DateTime.parse(visitor.exitTime!).toLocal() : null;
    final formattedExit = exitTime != null ? DateFormat('dd/MM/yy HH:mm').format(exitTime) : 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: visitor.visitorPhotoUrl != null
              ? NetworkImage(visitor.visitorPhotoUrl!)
              : null,
          child: visitor.visitorPhotoUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text(visitor.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DNI: ${visitor.dni}'),
            Text('Entrada: $formattedEntry'),
            Text('Salida: $formattedExit'),
          ],
        ),
        trailing: Chip(
          label: Text(visitor.status),
          backgroundColor: visitor.status == 'Activo' ? Colors.green[100] : Colors.grey[200],
        ),
      ),
    );
  }
}
