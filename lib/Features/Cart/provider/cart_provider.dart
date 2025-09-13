// // cart_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:coffee_shop/DATABASE_HELPER/cart_data.dart';

// final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
//   return CartNotifier();
// });

// class CartNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
//   CartNotifier() : super(const AsyncValue.loading()) {
//     _loadCartItems();
//   }

//   Future<void> _loadCartItems() async {
//     try {
//       final items = await DatabaseHelper.instance.getCartItems();
//       state = AsyncValue.data(items);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }
//   Future<void> updateQuantity(int id, int newQuantity) async {
//     if (newQuantity > 0) {
//       await DatabaseHelper.instance.updateCartItemQuantity(id, newQuantity);
//     } else {
//       await DatabaseHelper.instance.removeCartItem(id);
//     }
//     await _loadCartItems();
//   }

//   // Future<void> removeItem(int id) async {
//   //   await DatabaseHelper.instance.removeCartItem(id);
//   //   await _loadCartItems();
//   // }

// //   Future<void> checkout() async {
// //     // Add your checkout logic here
// //    try {
// //       // Add your checkout logic here
// //       await DatabaseHelper.instance.close();
// //       state = const AsyncValue.data([]);
// //     } catch (e, stack) {
// //       state = AsyncValue.error(e, stack);
// //     }
// //   }
// //   Future<void> removeAllItems() async {
// //   // try {
// //   //   state = const AsyncValue.loading(); // Show loading state
// //   //   await DatabaseHelper.instance.clearCart();
// //   //   state = const AsyncValue.data([]); // Set empty cart
// //   // } catch (e, stack) {
// //   //   state = AsyncValue.error(e, stack);
// //   //   rethrow;
// //   // }
// //    try {
// //       state = const AsyncValue.loading(); // Show loading state
// //       await DatabaseHelper.instance.clearCart();
// //       state = const AsyncValue.data([]); // Set empty cart
// //     } catch (e, stack) {
// //       // Don't rethrow the error, just set the error state
// //       state = AsyncValue.error(e, stack);
      
// //       // You can also revert to the previous state if needed
// //       // await _loadCartItems(); // Reload the current cart items
// //     }
// // }
// Future<void> removeItem(int id) async {
//     try {
//       await DatabaseHelper.instance.removeCartItem(id);
//       await _loadCartItems();
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }

//   Future<void> checkout() async {
//     try {
//       // Add your checkout logic here
//       await DatabaseHelper.instance.close();
//       state = const AsyncValue.data([]);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }

//   Future<void> removeAllItems() async {
//     try {
//       // Check if cart is already empty before trying to clear it
//       final currentItems = state.value;
      
//       if (currentItems == null || currentItems.isEmpty) {
//         // Cart is already empty, just set the state to empty
//         state = const AsyncValue.data([]);
//         return;
//       }
      
//       state = const AsyncValue.loading();
//       await DatabaseHelper.instance.clearCart();
//       state = const AsyncValue.data([]);
//     } catch (e, stack) {
//       // If there's an error, try to reload the current cart state
//       print('Error in removeAllItems: $e');
      
//       // Instead of setting error state, try to reload the cart
//       try {
//         await _loadCartItems();
//       } catch (loadError) {
//         // If reloading fails, set to empty state as fallback
//         state = const AsyncValue.data([]);
//       }
//     }
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_shop/DATABASE_HELPER/cart_data.dart';

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  CartNotifier() : super(const AsyncValue.loading()) {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final items = await DatabaseHelper.instance.getCartItems();
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateQuantity(int id, int newQuantity) async {
    try {
      if (newQuantity > 0) {
        await DatabaseHelper.instance.updateCartItemQuantity(id, newQuantity);
      } else {
        await DatabaseHelper.instance.removeCartItem(id);
      }
      await _loadCartItems();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeItem(int id) async {
    try {
      await DatabaseHelper.instance.removeCartItem(id);
      await _loadCartItems();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> checkout() async {
    try {
      // Add your checkout logic here
      await DatabaseHelper.instance.close();
      state = const AsyncValue.data([]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeAllItems() async {
    try {
      // Check if cart is already empty
      final currentState = state;
      if (currentState is AsyncData && currentState.value!.isEmpty) {
        return; // Cart is already empty, no action needed
      }
      
      state = const AsyncValue.loading();
      await DatabaseHelper.instance.clearCart();
      state = const AsyncValue.data([]);
    } catch (e, stack) {
      // If error occurs, try to reload current state
      try {
        await _loadCartItems();
      } catch (_) {
        state = const AsyncValue.data([]); // Fallback to empty cart
      }
    }
  }
}
