import 'dart:developer';

import 'package:coffee_shop/Features/Menu/Provider/paymentSuccessModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  final Map<String, dynamic> paymentData;

  const PaymentSuccessScreen({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Convert map to model
    final payment = PaymentSuccessModel.fromMap(paymentData);
    log('welcome in payment success ');
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Your initState logic here
    //   log('Payment screen mounted');

    //   // Auto navigate after 3 seconds
    //   Future.delayed(Duration(seconds: 3), () {
    //     if (context.mounted) {
    //       context.go('/navbar');
    //     }
    //   });
    // });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            _buildDetailRow('Order ID', payment.orderId),
            _buildDetailRow('Product', payment.productName),
            _buildDetailRow('Quantity', payment.quantity.toString()),
            _buildDetailRow('Amount', '\$${payment.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Payment ID', payment.paymentId),
            _buildDetailRow('Status', payment.status),
            _buildDetailRow('Completed', _formatDate(payment.completedAt)),
            if (payment.signature != null)
              _buildDetailRow('Signature', payment.signature!),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.go('/navbar');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
