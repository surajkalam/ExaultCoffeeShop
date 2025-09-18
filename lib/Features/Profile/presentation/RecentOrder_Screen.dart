import 'package:coffee_shop/Features/Menu/Provider/PaymentProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentOrderScreen extends ConsumerStatefulWidget {
  const RecentOrderScreen({super.key});

  @override
  ConsumerState<RecentOrderScreen> createState() => _RecentOrderScreenState();
}

class _RecentOrderScreenState extends ConsumerState<RecentOrderScreen> {
  @override
  void initState() {
    super.initState();
    // You might need to load payments from Firebase here
    // If you're using Firebase, you'll need to implement a method to fetch orders
  }

  @override
  Widget build(BuildContext context) {
    // If you're using Firebase for recent orders, you'll need to watch a different provider
    // or stream that fetches orders from Firebase
    
    // For now, let's assume you want to show the last successful payment
    final paymentState = ref.watch(paymentProvider);
    
    if (paymentState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Show the last payment data if available
    if (paymentState.paymentData == null) {
      return const Center(child: Text('No recent orders'));
    }
    
    final payment = paymentState.paymentData!;
    return ListView(
      children: [
        ListTile(
          title: Text(payment['productName'] ?? 'Unknown Product'),
          subtitle: Text('Quantity: ${payment['quantity'] ?? 1}'),
          trailing: Text('\$${payment['amount']?.toStringAsFixed(2) ?? '0.00'}'),
        ),
      ],
    );
  }
}