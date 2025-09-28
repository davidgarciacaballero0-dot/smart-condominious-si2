import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/visitor_log_model.dart';
import '../services/security_service.dart';
import 'add_visitor_log_page.dart';
import 'visitor_history_page.dart';

class SecurityDashboardPage extends StatefulWidget {
  const SecurityDashboardPage({Key? key}) : super(key: key);
  @override
  _SecurityDashboardPageState createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends State<SecurityDashboardPage> {
  final _securityService = SecurityService();
  Future<List<VisitorLog>>? _activeVisitorsFuture;

  @override
  void initState() {
    super.initState();
    _loadActiveVisitors();
  }

  // Carga o recarga la lista de visitantes activos
  void _loadActiveVisitors() {
    setState(() {
      _activeVisitorsFuture = _securityService.getActiveVisitors();
    });
  }

  // Muestra un diálogo de confirmación y registra la salida
  Future<void> _registerExit(int visitorLogId) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Salida'),
        content: const Text(
            '¿Estás seguro de que quieres registrar la salida de este visitante?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, Registrar Salida')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _securityService.registerVisitorExit(visitorLogId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Salida registrada con éxito'
                : 'Error al registrar la salida'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
      if (success) {
        _loadActiveVisitors(); // Recarga la lista si la salida fue exitosa
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Seguridad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ver Historial Completo',
            onPressed: () {
              // Navegaremos a la página de historial en un paso futuro
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VisitorHistoryPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadActiveVisitors(),
        child: FutureBuilder<List<VisitorLog>>(
          future: _activeVisitorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Error al cargar los visitantes activos.'));
            }
            final visitors = snapshot.data ?? [];
            if (visitors.isEmpty) {
              return const Center(
                child: Text(
                  'No hay visitantes activos en el condominio.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: visitors.length,
              itemBuilder: (context, index) {
                final visitor = visitors[index];
                return _buildVisitorCard(visitor);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddVisitorLogPage()),
          );
          if (result == true) {
            _loadActiveVisitors();
          }
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('REGISTRAR ENTRADA'),
      ),
    );
  }

  // Widget para construir la tarjeta de cada visitante
  Widget _buildVisitorCard(VisitorLog visitor) {
    final entryTime = DateTime.parse(visitor.entryTime).toLocal();
    final formattedTime = DateFormat('HH:mm \'hs\'').format(entryTime);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: visitor.visitorPhotoUrl != null
                  ? NetworkImage(visitor.visitorPhotoUrl!)
                  : null,
              child: visitor.visitorPhotoUrl == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitor.fullName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('DNI: ${visitor.dni}'),
                  Text('Visita a: ${visitor.housingUnit}'),
                  Text('Entrada: $formattedTime'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _registerExit(visitor.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Salida'),
            ),
          ],
        ),
      ),
    );
  }
}
