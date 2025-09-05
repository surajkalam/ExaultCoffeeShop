import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Provider for Firebase Firestore instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Provider for Firebase Auth instance
final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provider for the current user's email (sanitized for Firestore)
final userEmailProvider = Provider<String?>((ref) {
  final user = ref.watch(authProvider).currentUser;
  return user?.email?.replaceAll('.', '_');
});

// Main favorites provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<void>>((ref) {
      return FavoritesNotifier(
        firestore: ref.watch(firestoreProvider),
        getEmail: () => ref.read(
          userEmailProvider,
        ), // Using read instead of watch to avoid reactivity
      );
    });

class FavoritesNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseFirestore firestore;
  final String? Function() getEmail;

  FavoritesNotifier({required this.firestore, required this.getEmail})
    : super(const AsyncValue.data(null));

  Future<void> toggleFavorite(Map<String, dynamic> itemData) async {
    state = const AsyncValue.loading();
    try {
      final userEmail = getEmail();
      if (userEmail == null) throw Exception('User not logged in');

      final itemName = itemData['name'];
      final favoritesRef = firestore
          .collection('users')
          .doc(userEmail)
          .collection('favorites')
          .doc(itemName);

      final doc = await favoritesRef.get();

      if (doc.exists) {
        await favoritesRef.delete();
      } else {
        await favoritesRef.set({
          ...itemData,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> isFavorite(String itemName) async {
    try {
      final userEmail = getEmail();
      if (userEmail == null) return false;

      final doc = await firestore
          .collection('users')
          .doc(userEmail)
          .collection('favorites')
          .doc(itemName)
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}

//add cart provider

// providers.dart
final favoritesStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final userEmail = ref.watch(userEmailProvider);
  final firestore = ref.watch(firestoreProvider);

  if (userEmail == null) return Stream.value([]);

  return firestore
      .collection('users')
      .doc(userEmail)
      .collection('favorites')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => doc.data()..['id'] = doc.id)
          .toList());
});