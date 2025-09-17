import 'dart:developer';

import 'package:coffee_shop/Features/Cart/provider/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../../../core/core.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Welcome cart screen');
    final cartAsync = ref.watch(cartProvider);
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    log('🔄 Cart provider state: ${cartAsync.toString()}');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List couponlist = [
      'Assets/Images/Coffee lovers _ Voucher for a free cappuccino - Maria Palienko (1).jpg',
      'Assets/Images/Coupon (1).jpg',
      'Assets/Images/coupon2.jpg',
      'Assets/Images/coupon 3.jpg',
    ];

    // Listen for cart changes
    ref.listen(cartProvider, (_, state) {
      state.when(
        data: (items) => log('Cart items in state: $items'),
        loading: () => log('Loading cart...'),
        error: (e, _) => log('Error: $e'),
      );
    });

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: CustomAppBar(
        titleText: 'My Cart ',
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final cartState = ref.watch(cartProvider);
              return cartState.maybeWhen(
                data: (items) => items.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Iconsax.trash, color: Colors.black),
                        onPressed: () => _showClearCartDialog(
                          context,
                          ref,
                          colorScheme,
                          textTheme,
                        ),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: cartAsync.when(
        loading: () => _buildLoadingState(colorScheme, textTheme),
        error: (error, stack) =>
            _buildErrorState(error, colorScheme, textTheme),
        data: (items) {
          log('✅ Cart data received: ${items.length} items');
          if (items.isEmpty) {
            log('📭 Cart is empty');
            return _buildEmptyState(colorScheme, textTheme);
          }

          // Calculate total price
          double total = items.fold(0, (sum, item) {
            return sum + (item['price'] * (item['quantity'] ?? 1));
          });
          log('💰 Total calculated: ₹$total');

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  children: [
                    // Cart items
                    ...items
                        .map((item) => _buildCartItem(context, ref, item))
                        // ignore: unnecessary_to_list_in_spreads
                        .toList(),

                    const SizedBox(height: 20),

                    // Apply coupon code section
                    _buildCouponSection(couponlist),

                    const SizedBox(height: 20),

                    // Order summary
                    _buildOrderSummary(total),
                  ],
                ),
              ),

              // Checkout button
              _buildCheckoutButton(context, total, items),
            ],
          );
        },
      ),
    );
  }

  // Show confirmation dialog for clearing cart
  void _showClearCartDialog(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    // Get current cart state
    final cartState = ref.read(cartProvider);

    cartState.maybeWhen(
      data: (items) {
        if (items.isEmpty) {
          // Show message that cart is already empty
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your cart is already empty'),
              backgroundColor: colorscheme.secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          return;
        }

        // Show confirmation dialog for non-empty cart
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Clear Cart',
              style: texttheme.bodyLarge?.copyWith(color: colorscheme.primary),
            ),
            content: Text(
              'Are you sure you want to remove all ${items.length} items from your cart?',
              style: texttheme.bodySmall?.copyWith(
                color: colorscheme.secondary,
                fontSize: 11,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: texttheme.labelMedium?.copyWith(
                    color: colorscheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ref.read(cartProvider.notifier).removeAllItems();
                  // ignore: use_build_context_synchronously
                  context.pop();
                },
                child: Text(
                  'Clear All',
                  style: texttheme.labelMedium?.copyWith(
                    color: colorscheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      orElse: () {
        // Handle loading or error states
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot clear cart at this time'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
    );
  }

  // ... rest of your methods remain the same (loadingState, errorState, emptyState, etc.)
  // Build loading state
  Widget _buildLoadingState(ColorScheme colorscheme, TextTheme texttheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorscheme.secondaryFixed),
          const SizedBox(height: 16),
          Text(
            'Loading your cart...',
            style: texttheme.labelLarge?.copyWith(
              color: colorscheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  // Build error state
  // ignore: strict_top_level_inference
  Widget _buildErrorState(error, ColorScheme colorscheme, TextTheme texttheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 48, color: colorscheme.secondaryFixed),
          const SizedBox(height: 16),
          Text(
            'Error loading cart items',
            style: texttheme.bodySmall?.copyWith(color: colorscheme.error),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: texttheme.bodySmall?.copyWith(
              color: colorscheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  // Build empty state
  Widget _buildEmptyState(ColorScheme colorscheme, TextTheme texttheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //  Icon(Iconsax.shopping_cart, size: 64, color: colorscheme.secondaryFixed),
          Lottie.asset('Assets/Icons/Empty Cart.json', height: 200, width: 200),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: texttheme.bodyMedium?.copyWith(
              color: colorscheme.primaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious items to get started',
            style: texttheme.bodySmall?.copyWith(color: colorscheme.secondary),
          ),
        ],
      ),
    );
  }

  // Build cart item card
  Widget _buildCartItem(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> item,
  ) {
    final quantity = item['quantity'] ?? 1;
    final itemPrice = item['price'] * quantity;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (context.mounted) {
              context.pushNamed(
                'product',
                pathParameters: {'id': item['name'].toString()},
                extra: item,
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E2D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: item['image'] != null
                      ? Image.network(item['image'], fit: BoxFit.cover)
                      : const Icon(
                          Iconsax.coffee,
                          color: Color(0xFFC67C4E),
                          size: 32,
                        ),
                ),
                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Type and Name
                      Text(
                        item['category'] ?? 'Cappuccino',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9B9B9B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['name'] ?? 'Unnamed Item',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Price and Quantity Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${itemPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFC67C4E),
                            ),
                          ),
                          _buildQuantityControls(ref, item, quantity),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
            onPressed: () =>
                ref.read(cartProvider.notifier).removeItem(item['id']),
          ),
        ),
      ],
    );
  }

  // Build quantity controls
  Widget _buildQuantityControls(
    WidgetRef ref,
    Map<String, dynamic> item,
    int quantity,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2E2D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Decrease button
          IconButton(
            onPressed: () {
              if (quantity > 1) {
                ref
                    .read(cartProvider.notifier)
                    .updateQuantity(item['id'], quantity - 1);
              }
            },
            icon: Icon(
              Icons.remove,
              size: 18,
              color: quantity > 1
                  ? const Color(0xFFC67C4E)
                  : const Color(0xFF9B9B9B),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36,
              maxWidth: 36,
              minHeight: 36,
              maxHeight: 36,
            ),
          ),

          // Quantity display
          Text(
            quantity.toString(),
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          // Increase button
          IconButton(
            onPressed: () {
              ref
                  .read(cartProvider.notifier)
                  .updateQuantity(item['id'], quantity + 1);
            },
            icon: const Icon(Icons.add, size: 18, color: Color(0xFFC67C4E)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36,
              maxWidth: 36,
              minHeight: 36,
              maxHeight: 36,
            ),
          ),
        ],
      ),
    );
  }

  // Build coupon section
  Widget _buildCouponSection(List couponlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            const Icon(
              Iconsax.discount_shape,
              color: Color(0xFFC67C4E),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Apply Coupon Code',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: couponlist.length,
            itemBuilder: (context, listindex) => Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white),
              child: Image(
                image: AssetImage(couponlist[listindex]),
                fit: BoxFit.cover,
                height: 80,
                width: 180,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build order summary
  Widget _buildOrderSummary(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Row(
            children: [
              Text(
                'Order Summary',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Delivery Charges
          _buildSummaryRow('Delivery Charges', '₹40.00'),
          const SizedBox(height: 12),

          // Taxes
          _buildSummaryRow('Taxes', '₹10.87'),
          const SizedBox(height: 12),
          // Divider
          const Divider(height: 1, color: Color(0xFFEAEAEA)),
          const SizedBox(height: 12),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                '₹${(total + 40 + 10.87).toStringAsFixed(2)}',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFC67C4E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build summary row
  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: const Color(0xFF9B9B9B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Build checkout button
  Widget _buildCheckoutButton(
    BuildContext context,
    double total,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      padding:  EdgeInsets.only(bottom:60,left: 20,right: 20,top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            _proceedToCheckout(context, total, items);
          },
          style: ElevatedButton.styleFrom(
            
            backgroundColor: const Color(0xFFC67C4E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            'PAY NOW',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Proceed to checkout method
  void _proceedToCheckout(
    BuildContext context,
    double total,
    List<Map<String, dynamic>> items,
  ) {
    log('Proceeding to checkout with total: ₹$total');
    // Navigate to checkout screen
    // context.push('/checkout', extra: {'total': total, 'items': items});
    context.push('/payment-method');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to checkout with ${items.length} items'),
        backgroundColor: const Color(0xFF36C07E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
