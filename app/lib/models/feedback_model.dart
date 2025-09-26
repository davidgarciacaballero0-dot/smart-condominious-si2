// lib/models/feedback_model.dart

class FeedbackReport {
  final int id;
  final String title;
  final String description;
  final String status;

  FeedbackReport({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory FeedbackReport.fromJson(Map<String, dynamic> json) {
    return FeedbackReport(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
    );
  }
}
