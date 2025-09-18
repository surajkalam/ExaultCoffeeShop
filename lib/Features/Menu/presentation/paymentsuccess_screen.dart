import 'package:coffee_shop/Features/Menu/Provider/PaymentProvider.dart';
import 'package:coffee_shop/Features/Profile/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class PaymentSuccessScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> paymentData;
  const PaymentSuccessScreen({super.key, required this.paymentData});

  @override
  ConsumerState<PaymentSuccessScreen> createState() =>
      _PaymentSuccessScreenState();
}
class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      _storePaymentData();
    });
    Timer(Duration(seconds: 2), () {
      context.go('/navbar');
    });
  }
    void _storePaymentData() {
    // Extract data from paymentData map and convert to PaymentData model
    final payment = PaymentData(
      productName: widget.paymentData['productName'] ?? 'Unknown Product',
      quantity: widget.paymentData['quantity'] ?? 1,
      price: widget.paymentData['price']?.toDouble() ?? 0.0,
      totalPrice: widget.paymentData['totalPrice']?.toDouble() ?? 0.0,
      status: widget.paymentData['status'] ?? 'completed',
      completedAt: DateTime.now(),
    );

    // Store in database
   ref.read(paymentProvider.notifier).addPayment(payment);
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'Assets/Icons/Success.json',
              height: height * 0.5,
              width: width * 0.9,
              fit: BoxFit.fill,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/navbar');
            },
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
