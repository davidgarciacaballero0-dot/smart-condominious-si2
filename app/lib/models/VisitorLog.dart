// Pega este código en tu archivo VisitorLog.dart

// ignore_for_file: file_names

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} // Pega este código en tu archivo VisitorLog.dart

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} // Pega este código en tu archivo VisitorLog.dart

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} // Pega este código en tu archivo VisitorLog.dart

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} // Pega este código en tu archivo VisitorLog.dart

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} // Pega este código en tu archivo VisitorLog.dart

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
} // Pega este código en tu archivo VisitorLog.dart

class VisitorLog {
  final int id;
  final String visitorName;
  final String ci;
  final String residentName;
  final String? licensePlate; // Puede ser nulo
  final DateTime entryTime;
  final DateTime? exitTime; // Puede ser nulo

  const VisitorLog({
    required this.id,
    required this.visitorName,
    required this.ci,
    required this.residentName,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  // Este 'factory constructor' es clave: convierte los datos de la API
  // (en formato JSON) a un objeto VisitorLog que tu app puede usar.
  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      ci: json['ci'],
      residentName: json['resident_name'],
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      // Revisa si 'exit_time' no es nulo antes de intentar convertirlo
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
}
