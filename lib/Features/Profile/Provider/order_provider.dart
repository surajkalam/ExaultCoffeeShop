// order_provider.dart
import 'package:coffee_shop/Features/Profile/data/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, List<OrderItem>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<List<OrderItem>> {
  OrderNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add order to Firestore and local state
  Future<void> addOrder(OrderItem order) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Add to Firestore
      final docRef = await _firestore
          .collection('users')
          .doc(user.phoneNumber)
          .collection('recentOrders')
          .add(order.toMap());

      // Update local state with the generated ID
      final newOrder = order.copyWith(id: docRef.id);
      state = [newOrder, ...state];
      
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  // Fetch user's orders
  Future<void> fetchUserOrders() async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.phoneNumber == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(user.phoneNumber)
          .collection('recentOrders')
          .orderBy('orderDate', descending: true)
          .get();

      final orders = snapshot.docs
          .map((doc) => OrderItem.fromMap(doc.data(), doc.id))
          .toList();

      state = orders;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Clear all orders
  void clearOrders() {
    state = [];
  }
}