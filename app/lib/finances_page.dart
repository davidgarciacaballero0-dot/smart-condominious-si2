// ignore_for_file: use_super_parameters

import 'package:app/models/payment_model.dart';
import 'package:app/paymente_detail_page.dart';
import 'package:flutter/material.dart';

class PaymentListItem extends StatelessWidget {
  final Payment payment;
  const PaymentListItem({Key? key, required this.payment}) : super(key: key);

  // (La función _getStatusStyle no cambia)

  @override
  Widget build(BuildContext context) {
    // ... (El código de la tarjeta no cambia hasta el onTap)

    return Card(
      child: InkWell(
        onTap: () {
          // --- NAVEGACIÓN A LA PÁGINA DE DETALLE ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentDetailPage(payment: payment),
            ),
          );
        },
        // ... (El resto del diseño de la tarjeta no cambia)
      ),
    );
  }
}
