enum PaymentStatus { pagado, pendiente, vencido }

enum PaymentType { expensa, servicio } // <-- AÑADIMOS ESTA LÍNEA

class Payment {
  final String id;
  final String concept;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  final PaymentType type; // <-- AÑADIMOS ESTA LÍNEA
  final DateTime? paymentDate;

  const Payment({
    required this.id,
    required this.concept,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.type = PaymentType.expensa, // <-- Por defecto, será una expensa
    this.paymentDate,
  });

  Null get month => null;

  Null get year => null;
}
