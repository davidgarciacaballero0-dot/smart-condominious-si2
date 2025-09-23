import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/mock_data.dart';
import 'models/security_incident_model.dart';

class VisitorExitPage extends StatefulWidget {
  const VisitorExitPage({super.key});

  @override
  State<VisitorExitPage> createState() => _VisitorExitPageState();
}

class _VisitorExitPageState extends State<VisitorExitPage> {
  late List<VisitorLog> _currentVisitors;

  @override
  void initState() {
    super.initState();
    _updateVisitorList();
  }

  void _updateVisitorList() {
    _currentVisitors =
        mockVisitorLogs.where((log) => log.exitTime == null).toList();
  }

  void _registerExit(String id) {
    setState(() {
      final visitor = mockVisitorLogs.firstWhere((log) => log.id == id);
      visitor.exitTime = DateTime.now();
      _updateVisitorList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Salida registrada con éxito.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Salida de Visitante'),
      ),
      body: _currentVisitors.isEmpty
          ? const Center(
              child: Text(
                'No hay visitantes registrados actualmente.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _currentVisitors.length,
              itemBuilder: (context, index) {
                final visitor = _currentVisitors[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor.visitorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Visita a: ${visitor.visitingTo}'),
                        Text(
                            'CI: ${visitor.visitorCI}'), // <-- CAMBIO REALIZADO
                        if (visitor.vehiclePlate != null)
                          Text('Placa: ${visitor.vehiclePlate}'),
                        const SizedBox(height: 4),
                        Text(
                          'Ingreso: ${DateFormat('dd/MM/yyyy HH:mm').format(visitor.entryTime)} hrs',
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _registerExit(visitor.id),
                            icon: const Icon(Icons.logout_outlined),
                            label: const Text('REGISTRAR SALIDA'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
