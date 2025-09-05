// // ignore: file_names
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:flutter/foundation.dart';

// class RazorpayService {
//   late Razorpay _razorpay;

//   void initializeRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void openCheckout({
//     required String amount,
//     required String name,
//     required String description,
//     required String orderId,
//   }) {
//     var options = {
//       'key': 'rzp_test_R7HT7by76iqrT3', // Replace with your actual key
//       'amount': amount, // amount in paise (e.g., 100 = ₹1)
//       'name': 'exalut_Coffee_Shop',
//       'description': description,
//       'prefill': {'contact': '9999999999', 'email': 'customer@email.com'},
//       'external': {
//         'wallets': ['paytm', 'phonepe'],
//       },
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Razorpay Error: $e');
//       }
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     // Handle payment success
//     if (kDebugMode) {
//       print('Payment Success: ${response.paymentId}');
//     }
//     // You can add your success logic here (e.g., update order status)
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Handle payment failure
//     if (kDebugMode) {
//       print('Payment Error: ${response.code} - ${response.message}');
//     }
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     // Handle external wallet
//     if (kDebugMode) {
//       print('External Wallet: ${response.walletName}');
//     }
//   }

//   void dispose() {
//     _razorpay.clear();
//   }
// }
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onError;

  void initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required String amount,
    required String name,
    required String description,
    required String orderId,
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onError,
  }) {
    _onSuccess = onSuccess;
    _onError = onError;

    var options = {
      'key': 'rzp_test_R7HT7by76iqrT3',
      'amount': amount,
      'name': name,
      'description': description,
      'prefill': {
        'contact': '9999999999',
        'email': 'customer@email.com'
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (kDebugMode) {
        print('Razorpay Error: $e');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (kDebugMode) {
      print('Payment Success: ${response.paymentId}');
    }
    _onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (kDebugMode) {
      print('Payment Error: ${response.code} - ${response.message}');
    }
    _onError?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (kDebugMode) {
      print('External Wallet: ${response.walletName}');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
