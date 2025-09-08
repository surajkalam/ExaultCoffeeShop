// import 'dart:developer';
// import 'package:coffee_shop/Features/Cart/provider/cart_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';

// class CartScreen extends ConsumerWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     log('Welcome cart screen');
//     final cartAsync = ref.watch(cartProvider);
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     log('🔄 Cart provider state: ${cartAsync.toString()}');

//     // Listen for cart changes
//     ref.listen(cartProvider, (_, state) {
//       state.when(
//         data: (items) => log('Cart items in state: $items'),
//         loading: () => log('Loading cart...'),
//         error: (e, _) => log('Error: $e'),
//       );
//     });

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: _buildAppBar(context),
//       body: cartAsync.when(
//         loading: () => _buildLoadingState(),
//         error: (error, stack) => _buildErrorState(error),
//         data: (items) {
//           log('✅ Cart data received: ${items.length} items');
//           if (items.isEmpty) {
//             log('📭 Cart is empty');
//             return _buildEmptyState();
//           }

//           // Calculate total price
//           double total = items.fold(0, (sum, item) {
//             return sum + (item['price'] * (item['quantity'] ?? 1));
//           });
//           log('💰 Total calculated: ₹$total');

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     final item = items[index];
//                     log('🛍️ Building cart item $index: ${item['name']}');
//                     return InkWell(
//                       onTap: () {
//                         context.pushNamed(
//                           'product',
//                           pathParameters: {'id': item['name'].toString()},
//                           extra: item,
//                         );
//                       },
//                       child: _buildCartItem(context, ref, height, width, item),
//                     );
//                   },
//                 ),
//               ),
//               _buildTotalSection(total, context, items),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Build iOS-style app bar
//   // ignore: strict_top_level_inference
//   PreferredSizeWidget _buildAppBar(context) {
//     return AppBar(
//       backgroundColor: AppColors.background,
//       elevation: 0,
//       centerTitle: true,
//       title: Text(
//         'My Cart',
//         style: GoogleFonts.dmSans(
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//           color: AppColors.primaryDark,
//         ),
//       ),
//       leading: IconButton(
//         icon: Icon(Iconsax.arrow_left, color: AppColors.primaryDark),
//         onPressed: () => Navigator.maybePop(context),
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Iconsax.trash, color: AppColors.primaryDark),
//           onPressed: () {
//             // Add clear cart functionality
//           },
//         ),
//       ],
//     );
//   }

//   // Build loading state
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: AppColors.primary),
//           SizedBox(height: 16),
//           Text(
//             'Loading your cart...',
//             style: GoogleFonts.dmSans(
//               fontSize: 16,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build error state
//   // ignore: strict_top_level_inference
//   Widget _buildErrorState(error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Iconsax.warning_2, size: 48, color: Colors.orange),
//           SizedBox(height: 16),
//           Text(
//             'Error loading cart items',
//             style: GoogleFonts.dmSans(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primaryDark,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Please try again later',
//             style: GoogleFonts.dmSans(
//               fontSize: 14,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build empty state
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Iconsax.shopping_cart, size: 64, color: AppColors.textSecondary),
//           SizedBox(height: 16),
//           Text(
//             'Your cart is empty',
//             style: GoogleFonts.dmSans(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primaryDark,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Add some delicious items to get started',
//             style: GoogleFonts.dmSans(
//               fontSize: 14,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build cart item card
//   Widget _buildCartItem(
//     BuildContext context,
//     WidgetRef ref,
//     double height,
//     double width,
//     Map<String, dynamic> item,
//   ) {
//     final hasImage = item['image'] != null;
//     final rating = item['rating'] ?? 0.0;
//     final quantity = item['quantity'] ?? 1;
//     final itemPrice = item['price'] * quantity;
//     log('$item');
//     return Container(
//       margin: EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 8),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Container(
//                     height: height * 0.12,
//                     width: width * 0.22,
//                     color: AppColors.primaryLight,
//                     child: hasImage
//                         ? Image.asset(
//                             item['image'],
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, _, _) =>
//                                 _buildItemImagePlaceholder(),
//                           )
//                         : _buildItemImagePlaceholder(),
//                   ),
//                 ),
//                 SizedBox(width: 12),

//                 // Product Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Product Name
//                       Text(
//                         item['name'] ?? 'Unnamed Item',
//                         style: GoogleFonts.dmSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.primaryDark,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),

//                       // Rating
//                       _buildItemRating(rating),
//                       SizedBox(height: 8),

//                       // Price and Quantity Controls
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '₹${itemPrice.toStringAsFixed(2)}',
//                             style: GoogleFonts.dmSans(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                           _buildQuantityControls(ref, item, quantity),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Delete Button
//           Positioned(
//             top: 8,
//             right: 8,
//             child: IconButton(
//               icon: Icon(Iconsax.trash, size: 20, color: Colors.red),
//               onPressed: () =>
//                   ref.read(cartProvider.notifier).removeItem(item['id']),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build item rating
//   Widget _buildItemRating(double rating) {
//     return Row(
//       children: [
//         ...List.generate(5, (starIndex) {
//           IconData icon;
//           if (starIndex < rating.floor()) {
//             icon = Iconsax.star1;
//           } else if (starIndex == rating.floor() && rating % 1 >= 0.5) {
//             icon = Iconsax.star;
//           } else {
//             icon = Iconsax.star;
//           }
//           return Icon(icon, color: Colors.amber, size: 14);
//         }),
//         SizedBox(width: 4),
//         Text(
//           rating.toStringAsFixed(1),
//           style: GoogleFonts.dmSans(
//             fontSize: 12,
//             color: AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }

//   // Build quantity controls
//   Widget _buildQuantityControls(
//     WidgetRef ref,
//     Map<String, dynamic> item,
//     int quantity,
//   ) {
//     return Container(
//       height: 28, // Fixed height
//       decoration: BoxDecoration(
//         color: AppColors.primaryLight,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.lightBorder),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min, // Important: don't expand
//         mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out evenly
//         children: [
//           // Decrease button
//           SizedBox(
//             width: 24, // Fixed width for button
//             child: IconButton(
//               onPressed: () {
//                 if (quantity > 1) {
//                   ref
//                       .read(cartProvider.notifier)
//                       .updateQuantity(item['id'], quantity - 1);
//                 }
//               },
//               icon: Icon(
//                 Iconsax.minus,
//                 size: 12,
//                 color: quantity > 1
//                     ? AppColors.primary
//                     : AppColors.textSecondary,
//               ),
//               padding: EdgeInsets.zero,
//               constraints: BoxConstraints(
//                 minWidth: 24,
//                 maxWidth: 24,
//                 minHeight: 24,
//                 maxHeight: 24,
//               ),
//             ),
//           ),

//           // Quantity display - centered with fixed width
//           Container(
//             width: 20, // Fixed width for quantity
//             alignment: Alignment.center,
//             child: Text(
//               quantity.toString(),
//               style: GoogleFonts.dmSans(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primaryDark,
//               ),
//             ),
//           ),

//           // Increase button
//           SizedBox(
//             width: 24, // Fixed width for button
//             child: IconButton(
//               onPressed: () {
//                 ref
//                     .read(cartProvider.notifier)
//                     .updateQuantity(item['id'], quantity + 1);
//               },
//               icon: Icon(Iconsax.add, size: 12, color: AppColors.primary),
//               padding: EdgeInsets.zero,
//               constraints: BoxConstraints(
//                 minWidth: 24,
//                 maxWidth: 24,
//                 minHeight: 24,
//                 maxHeight: 24,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build item image placeholder
//   Widget _buildItemImagePlaceholder() {
//     return Center(
//       child: Icon(
//         Iconsax.coffee,
//         size: 32,
//         // ignore: deprecated_member_use
//         color: AppColors.primary.withOpacity(0.3),
//       ),
//     );
//   }

//   // Build total section with checkout button
//   Widget _buildTotalSection(
//     double total,
//     BuildContext context,
//     List<Map<String, dynamic>> items,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: AppColors.lightBorder)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             offset: Offset(0, -2),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Total Price
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total:',
//                 style: GoogleFonts.dmSans(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.primaryDark,
//                 ),
//               ),
//               Text(
//                 '₹${total.toStringAsFixed(2)}',
//                 style: GoogleFonts.dmSans(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),

//           // Checkout Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 _proceedToCheckout(context, total, items);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Iconsax.wallet, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     'Proceed to Checkout',
//                     style: GoogleFonts.dmSans(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Proceed to checkout method
//   void _proceedToCheckout(
//     BuildContext context,
//     double total,
//     List<Map<String, dynamic>> items,
//   ) {
//     log('Proceeding to checkout with total: ₹$total');
//     // Navigate to checkout screen
//     context.push('/checkout', extra: {'total': total, 'items': items});

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Proceeding to checkout with ${items.length} items'),
//         backgroundColor: AppColors.accent,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }
// }

// // Define a color palette for the app
// class AppColors {
//   static const Color primary = Color(0xFFC67C4E);
//   static const Color primaryDark = Color(0xFF372213);
//   static const Color primaryLight = Color(0xFFFFF5EE);
//   static const Color accent = Color(0xFF36C07E);
//   static const Color background = Color(0xFFF9F9F9);
//   static const Color textPrimary = Color(0xFF2F2D2C);
//   static const Color textSecondary = Color(0xFF9B9B9B);
//   static const Color lightBorder = Color(0xFFEAEAEA);
// }
import 'dart:developer';
import 'package:coffee_shop/Features/Cart/provider/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Welcome cart screen');
    final cartAsync = ref.watch(cartProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log('🔄 Cart provider state: ${cartAsync.toString()}');

    // Listen for cart changes
    ref.listen(cartProvider, (_, state) {
      state.when(
        data: (items) => log('Cart items in state: $items'),
        loading: () => log('Loading cart...'),
        error: (e, _) => log('Error: $e'),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: _buildAppBar(context),
      body: cartAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
        data: (items) {
          log('✅ Cart data received: ${items.length} items');
          if (items.isEmpty) {
            log('📭 Cart is empty');
            return _buildEmptyState();
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // Cart items
                    ...items.map((item) => _buildCartItem(context, ref, item)).toList(),
                    
                    const SizedBox(height: 20),
                    
                    // Apply coupon code section
                    _buildCouponSection(),
                    
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

  // Build iOS-style app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'My Cart',
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Colors.black),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.trash, color: Colors.black),
          onPressed: () {
            // Add clear cart functionality
          },
        ),
      ],
    );
  }

  // Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFFC67C4E)),
          const SizedBox(height: 16),
          Text(
            'Loading your cart...',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: const Color(0xFF9B9B9B),
            ),
          ),
        ],
      ),
    );
  }

  // Build error state
  Widget _buildErrorState(error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.warning_2, size: 48, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'Error loading cart items',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFF9B9B9B),
            ),
          ),
        ],
      ),
    );
  }

  // Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.shopping_cart, size: 64, color: Color(0xFF9B9B9B)),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious items to get started',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFF9B9B9B),
            ),
          ),
        ],
      ),
    );
  }

  // Build cart item card
  Widget _buildCartItem(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    final quantity = item['quantity'] ?? 1;
    final itemPrice = item['price'] * quantity;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
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
                ? Image.asset(
                    item['image'],
                    fit: BoxFit.cover,
                  )
                : const Icon(Iconsax.coffee, color: Color(0xFFC67C4E), size: 32),
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
    );
  }

  // Build quantity controls
  Widget _buildQuantityControls(WidgetRef ref, Map<String, dynamic> item, int quantity) {
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
                ref.read(cartProvider.notifier).updateQuantity(item['id'], quantity - 1);
              }
            },
            icon: Icon(
              Icons.remove,
              size: 18,
              color: quantity > 1 ? const Color(0xFFC67C4E) : const Color(0xFF9B9B9B),
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
              ref.read(cartProvider.notifier).updateQuantity(item['id'], quantity + 1);
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
  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Iconsax.discount_shape, color: Color(0xFFC67C4E), size: 24),
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
          const Icon(Iconsax.arrow_right_3, color: Color(0xFF9B9B9B), size: 20),
        ],
      ),
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
  Widget _buildCheckoutButton(BuildContext context, double total, List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.all(20),
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
  void _proceedToCheckout(BuildContext context, double total, List<Map<String, dynamic>> items) {
    log('Proceeding to checkout with total: ₹$total');
    // Navigate to checkout screen
    context.push('/checkout', extra: {'total': total, 'items': items});

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