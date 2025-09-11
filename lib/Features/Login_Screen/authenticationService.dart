// // // auth_notifier.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final authNotifierProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(
//   AuthNotifier.new,
// );

// class AuthNotifier extends Notifier<AsyncValue<User?>> {
//   @override
//   AsyncValue<User?> build() {
//     // Start with data(null) instead of loading to prevent initial spinner
//     return const AsyncValue.data(null);
//   }

//   Future<void> initialize() async {
//     // Listen to auth state changes
//     FirebaseAuth.instance.authStateChanges().listen((user) {
//       state = AsyncValue.data(user);
//     });
//   }

//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     state = const AsyncValue.loading();
//     try {
//       final userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       state = AsyncValue.data(userCredential.user);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       rethrow;
//     }
//   }

//   Future<void> signUpWithEmailAndPassword(String email, String password) async {
//     state = const AsyncValue.loading();
//     try {
//       final userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       state = AsyncValue.data(userCredential.user);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
// auth_notifier.dart
// auth_notifier.dart
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  String? _verificationId;
  String? _phoneNumber;

  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> initialize() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
  }
 
  // Existing email methods
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      state = AsyncValue.data(userCredential.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      state = AsyncValue.data(userCredential.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // Phone authentication methods - FIXED
  Future<void> verifyPhoneNumber(String phoneNumber, {Function(String)? onCodeSent}) async {
    state = const AsyncValue.loading();
    try {
      _phoneNumber = phoneNumber;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          state = AsyncValue.error(e, StackTrace.current);
          log('Verification failed: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          if (onCodeSent != null) {
            onCodeSent(verificationId); // Call the callback
          }
          state = const AsyncValue.data(null); // Reset to allow code input
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // FIXED: Removed duplicate parameter
  Future<void> signInWithPhoneNumber(String verificationId, String smsCode) async {
    state = const AsyncValue.loading();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      state = AsyncValue.data(userCredential.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}