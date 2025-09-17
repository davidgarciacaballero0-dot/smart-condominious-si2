// Usaremos un enum para definir los posibles estados de un pago.
// Esto es más seguro que usar strings ("Pagado", "Pendiente").
enum PaymentStatus { pagado, pendiente, vencido }

class Payment {
  final String id;
  final String concept; // Ej: "Expensas Enero 2025"
  final double amount;
  final DateTime dueDate; // Fecha de vencimiento
  final PaymentStatus status;
  final DateTime? paymentDate; // Fecha en que se pagó (opcional)

  const Payment({
    required this.id,
    required this.concept,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.paymentDate,
  });
}
