// ignore_for_file: file_names
// lib/models/visitor_log_model.dart

class VisitorLog {
  final int id;
  final String visitorFullName;
  final String visitorDocumentNumber;
  final String residentName;
  final DateTime entryDatetime;
  final DateTime? exitDatetime;
  final String status;

  VisitorLog({
    required this.id,
    required this.visitorFullName,
    required this.visitorDocumentNumber,
    required this.residentName,
    required this.entryDatetime,
    this.exitDatetime,
    required this.status,
  });

  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorFullName: json['visitor_full_name'],
      visitorDocumentNumber: json['visitor_document_number'],
      residentName: json['resident_name'],
      entryDatetime: DateTime.parse(json['entry_datetime']),
      exitDatetime: json['exit_datetime'] != null
          ? DateTime.parse(json['exit_datetime'])
          : null,
      status: json['status'],
    );
  }
}
