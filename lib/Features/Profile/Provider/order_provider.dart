// payment_provider.dart
import 'package:coffee_shop/Features/Profile/data/order_model.dart';
import 'package:flutter/foundation.dart';

import '../../../DATABASE_HELPER/payment_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final paymentProvider = ChangeNotifierProvider<PaymentProvider>((ref) {
  return PaymentProvider();
});


class PaymentProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<PaymentData> _payments = [];
  bool _isLoading = false;

  List<PaymentData> get payments => _payments;
  bool get isLoading => _isLoading;

  Future<void> loadPayments() async {
    _setLoading(true);
    _payments = await _dbHelper.getPayments();
    _setLoading(false);
  }

  Future<void> addPayment(PaymentData payment) async {
    await _dbHelper.insertPayment(payment);
    await loadPayments(); // This automatically refreshes the list
  }

  Future<void> deletePayment(int id) async {
    await _dbHelper.deletePayment(id);
    await loadPayments(); // This automatically refreshes the list
  }

  Future<void> clearAllPayments() async {
    await _dbHelper.clearPayments();
    await loadPayments(); // This automatically refreshes the list
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}