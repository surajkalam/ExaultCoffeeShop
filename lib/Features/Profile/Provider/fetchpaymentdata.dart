// providers/payment_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to fetch all payments for current user
final userPaymentsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user?.email == null) return Stream.value([]);

  final userEmail = user!.email!.replaceAll('.', '_');
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userEmail)
      .collection('payments')
      .orderBy('completedAt', descending: true) // Show latest first
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {...data, 'id': doc.id};
          }).toList());
});

// Provider for a specific payment
final specificPaymentProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, paymentId) {
  final user = FirebaseAuth.instance.currentUser;
  if (user?.email == null) return Stream.value({});

  final userEmail = user!.email!.replaceAll('.', '_');
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userEmail)
      .collection('payments')
      .doc(paymentId)
      .snapshots()
      .map((snapshot) => snapshot.data() ?? {});
});