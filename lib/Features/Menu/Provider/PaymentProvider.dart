
import 'dart:developer';
import 'package:coffee_shop/Services/Razorpay_Service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final razorpayServiceProvider = Provider<RazorpayService>((ref) {
  final service = RazorpayService();
  service.initializeRazorpay();
  return service;
});

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  return PaymentNotifier(
    ref.read(razorpayServiceProvider),
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

class PaymentState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final bool paymentSuccess;

  PaymentState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.paymentSuccess = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? paymentSuccess,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
      paymentSuccess: paymentSuccess ?? this.paymentSuccess,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final RazorpayService _razorpayService;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  // ignore: unused_field
  late String _currentUserEmail;
  late Map<String, dynamic> _paymentData;
  


  PaymentNotifier(this._razorpayService, this._firestore, this._auth)
    : super(PaymentState()) {
    _currentUserEmail = _auth.currentUser?.email ?? 'guest';
  }

  Future<void> initiatePayment({
    required num amount,
    required String productName,
    required int quantity,
    required String orderId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);


    // Store payment data for later use
    _paymentData = {
      'amount': amount.toDouble(),
      'productName': productName,
      'quantity': quantity,
      'orderId': orderId,
      'timestamp': DateTime.now(),
      'status': 'initiated',
    };

    try {
      final amountInPaise = (amount * 100).toInt().toString();

      _razorpayService.openCheckout(
        amount: amountInPaise,
        name: productName,
        description: '$quantity x $productName',
        orderId: orderId,
        onSuccess: _handlePaymentSuccess, // Add callback
        onError: _handlePaymentError, // Add callback
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initiate payment: $e',
      );
    }
  }

  // Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   try {
  //     // Update payment data with success info
  //     final paymentDetails = {
  //       ..._paymentData,
  //       'paymentId': response.paymentId,
  //       'orderId': response.orderId,
  //       'signature': response.signature,
  //       'status': 'completed',
  //       'completedAt': DateTime.now(),
  //     };

  //     // Save to Firebase
  //     await _savePaymentToFirebase(paymentDetails);

  //     state = state.copyWith(
  //       paymentSuccess: true,
  //       successMessage: 'Payment successful! Order ID: ${response.orderId}',
  //     );

  //   } catch (e) {
  //     state = state.copyWith(
  //       error: 'Payment successful but failed to save details: $e',
  //     );
  //   }
  // }
  // In your payment_provider.dart
  Future<Map<String, dynamic>> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //  log('Payment response: ${response.toJson()}');
    log('Stored payment data: $_paymentData');
    try {
      final orderId =
          _paymentData['orderId'] as String? ??
          'ORD_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      final completedPaymentData = {
      'amount': _paymentData['amount']?.toDouble() ?? 0.0,
      'productName': _paymentData['productName']?.toString() ?? 'Unknown Product',
      'quantity': _paymentData['quantity']?.toInt() ?? 1,
      'orderId': orderId,
      'paymentId': response.paymentId ?? 'N/A',
      'signature': response.signature,
      'status': 'completed', // ← CHANGED FROM 'initiated' to 'completed'
      'completedAt': now,
      'product':_paymentData['product' ] ?? Null,
      'timestamp': _paymentData['timestamp'] is DateTime 
          ? _paymentData['timestamp'] as DateTime 
          : now,
    };

      await _savePaymentToFirebase(completedPaymentData);

      state = state.copyWith(
        paymentSuccess: true,
        successMessage: 'Payment successful! Order ID: $orderId',
      );
       return completedPaymentData;
    } catch (e, stackTrace) {
      log('Error: $e');
      log('Stack trace: $stackTrace');
      state = state.copyWith(
        error: 'Payment successful but failed to save details: $e',
      );
      rethrow;
    }
  }

  Future<void> _savePaymentToFirebase(
    Map<String, dynamic> paymentDetails,
  ) async {
    // try {
    //   final user = _auth.currentUser;

    //   if (user == null) {
    //     // User not logged in - navigate to login screen
    //     _navigateToLogin();
    //     return;
    //   }
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user == null || user.email == null) {
        _navigateToLogin();
        throw Exception('User not logged in');
      }
      // Sanitize email for Firestore path
      final userEmail = user.email!.replaceAll('.', '_');

      // Use the existing user document
      await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('payments')
          .doc(paymentDetails['orderId'])
          .set(paymentDetails);

      log('Payment details saved to Firebase successfully');
    } catch (e) {
      log('Error saving to Firebase: $e');
      rethrow;
    }
  }

  void _navigateToLogin() {
    // You'll need to pass context or use a navigator key
    // For now, we'll handle this in the UI layer
    throw Exception('User not authenticated. Please login first.');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    state = state.copyWith(
      error: 'Payment failed: ${response.message}',
      paymentSuccess: false,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuccess() {
    state = state.copyWith(successMessage: null, paymentSuccess: false);
  }

  // In your PaymentNotifier class
  Map<String, dynamic> getLastPaymentData() {
    return _paymentData;
  }
}
