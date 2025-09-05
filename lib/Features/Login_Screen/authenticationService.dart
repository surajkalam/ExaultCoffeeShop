// // auth_notifier.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  @override
  AsyncValue<User?> build() {
    // Start with data(null) instead of loading to prevent initial spinner
    return const AsyncValue.data(null);
  }

  Future<void> initialize() async {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
  }

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
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
// auth_notifier.dart
// import 'package:google_sign_in/google_sign_in.dart';


// final authNotifierProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

// class AuthNotifier extends Notifier<AsyncValue<User?>> {
//   // final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

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
//       rethrow;
//     }
//   }

//   Future<void> signInWithGoogle() async {
//     state = const AsyncValue.loading();
//     try {
//       // Trigger the Google Sign-In flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         // User canceled the sign-in
//         state = const AsyncValue.data(null);
//         return;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = 
//           await googleUser.authentication;

//       // Create a new credential from the Google auth
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credentials
//       final UserCredential userCredential = 
      
//           await _auth.signInWithCredential(credential);
      
//       // Update state with the signed-in user
//       state = AsyncValue.data(userCredential.user);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       rethrow;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       // Sign out from Google
//       await _googleSignIn.signOut();
//       // Sign out from Firebase
//       await FirebaseAuth.instance.signOut();
//       // Update state to null
//       state = const AsyncValue.data(null);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       rethrow;
//     }
//   }
// }