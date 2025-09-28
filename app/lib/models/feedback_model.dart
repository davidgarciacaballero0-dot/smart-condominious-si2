// lib/models/feedback_model.dart
import 'package:flutter/material.dart';

class FeedbackItem {
  final int id;
  final String subject;
  final String message;
  final DateTime createdAt;

  FeedbackItem({
    required this.id,
    required this.subject,
    required this.message,
    required this.createdAt,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'],
      subject: json['subject'] ?? 'Sin Asunto',
      message: json['message'] ?? 'Sin Mensaje',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
