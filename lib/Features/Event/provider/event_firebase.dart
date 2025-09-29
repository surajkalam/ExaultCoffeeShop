// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Features/Event/model/event_model.dart';
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save booking to Firestore
  Future<String> saveBooking({
    required String userId,
    required EventBooking booking,
  }) async {
    try {
      final bookingRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .doc();

      final bookingData = booking.copyWith(bookingId: bookingRef.id).toMap();
      
      await bookingRef.set(bookingData);
      
      return bookingRef.id; // Return the document ID
    } catch (e) {
      throw Exception('Failed to save booking: $e');
    }
  }

  // Get user's bookings
  Stream<List<EventBooking>> getUserBookings(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventBooking.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Update booking status
  Future<void> updateBookingStatus({
    required String userId,
    required String bookingId,
    required String status,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': status,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  // Delete booking
  Future<void> deleteBooking({
    required String userId,
    required String bookingId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .doc(bookingId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }
}