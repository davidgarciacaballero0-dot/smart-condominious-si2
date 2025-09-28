// lib/pages/feedback_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/feedback_model.dart';
import '../services/profile_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _profileService = ProfileService();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Future<List<FeedbackItem>>? _feedbackFuture;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  void _loadFeedback() {
    setState(() {
      _feedbackFuture = _profileService.getMyFeedback();
    });
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final success = await _profileService.createFeedback(
        subject: _subjectController.text,
        message: _messageController.text,
      );
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Reclamo enviado con éxito'
              : 'Error al enviar el reclamo'),
          backgroundColor: success ? Colors.green : Colors.red,
        ));
        if (success) {
          _subjectController.clear();
          _messageController.clear();
          _loadFeedback(); // Recargamos el historial
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reclamos y Sugerencias')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeedbackForm(),
          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 16),
          _buildFeedbackHistory(),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enviar un nuevo reclamo',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextFormField(
            controller: _subjectController,
            decoration: const InputDecoration(
                labelText: 'Asunto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.subject)),
            validator: (value) =>
                (value ?? '').isEmpty ? 'El asunto es requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
                alignLabelWithHint: true),
            maxLines: 5,
            validator: (value) =>
                (value ?? '').isEmpty ? 'El mensaje es requerido' : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitFeedback,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 3, color: Colors.white))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Icon(Icons.send),
                          SizedBox(width: 8),
                          Text('ENVIAR')
                        ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeedbackHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de envíos',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        FutureBuilder<List<FeedbackItem>>(
          future: _feedbackFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError)
              return const Text('Error al cargar el historial.');
            final feedbackList = snapshot.data ?? [];
            if (feedbackList.isEmpty)
              return const Text('No has enviado ningún reclamo todavía.');

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(feedback.subject,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(feedback.message,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing:
                        Text(DateFormat('dd/MM/yy').format(feedback.createdAt)),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
