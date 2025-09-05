// cart_provider.dart
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
    if (newQuantity > 0) {
      await DatabaseHelper.instance.updateCartItemQuantity(id, newQuantity);
    } else {
      await DatabaseHelper.instance.removeCartItem(id);
    }
    await _loadCartItems();
  }

  Future<void> removeItem(int id) async {
    await DatabaseHelper.instance.removeCartItem(id);
    await _loadCartItems();
  }

  Future<void> checkout() async {
    // Add your checkout logic here
    await DatabaseHelper.instance.close();
    state = const AsyncValue.data([]);
  }
}
