// import 'dart:developer';

// import 'package:coffee_shop/Features/Cart/provider/cart_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:coffee_shop/App/appTheme.dart';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CartScreen extends ConsumerWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cartAsync = ref.watch(cartProvider);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     // In your CartScreen build method
//     ref.listen(cartProvider, (_, state) {
//       state.when(
//         data: (items) => log('Cart items in state: $items'),
//         loading: () => log('Loading cart...'),
//         error: (e, _) => log('Error: $e'),
//       );
//     });

//     return Scaffold(
//       appBar: AppBar(title: Text('My Cart'), centerTitle: true),
//       body: cartAsync.when(
//         loading: () => Center(child: CircularProgressIndicator()),
//         error: (error, stack) =>
//             Center(child: Text('Error loading cart items')),
//         data: (items) {
//           if (items.isEmpty) {
//             return Center(
//               child: Text(
//                 'Your cart is empty',
//                 style: GoogleFonts.dmSans(fontSize: 18),
//               ),
//             );
//           }

//           // Calculate total price
//           double total = items.fold(0, (sum, item) {
//             return sum + (item['price'] * (item['quantity'] ?? 1));
//           });

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     final item = items[index];
//                     final hasImage = item['image'] != null;
//                     final rating = item['rating'] ?? 0.0;
//                     final quantity = item['quantity'] ?? 1;

//                     return Stack(
//                       children: [
//                         Card(
//                           margin: EdgeInsets.symmetric(
//                             horizontal: width*0.013,
//                             vertical: height*0.007,
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(width*0.012),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: hasImage
//                                       ? Image.asset(
//                                           item['image'],
//                                           height: height * 0.12,
//                                           width: width * 0.25,
//                                           fit: BoxFit.cover,
//                                           errorBuilder: (_, __, ___) =>
//                                               Icon(Icons.fastfood, size: 40),
//                                         )
//                                       : Icon(Icons.fastfood, size: 40),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         item['name'] ?? 'Unnamed Item',
//                                         style: GoogleFonts.dmSans(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         softWrap: true,
//                                         overflow: TextOverflow.visible,
//                                       ),
//                                       SizedBox(height: 4),
//                                       Row(
//                                         children: [
//                                           ...List.generate(5, (starIndex) {
//                                             IconData icon;
//                                             if (starIndex < rating.floor()) {
//                                               icon = Icons.star;
//                                             } else if (starIndex ==
//                                                     rating.floor() &&
//                                                 rating % 1 >= 0.5) {
//                                               icon = Icons.star_half;
//                                             } else {
//                                               icon = Icons.star_border;
//                                             }
//                                             return Icon(
//                                               icon,
//                                               color: Colors.amber,
//                                               size: 16,
//                                             );
//                                           }),
//                                           SizedBox(width: 4),
//                                           Text(
//                                             rating.toStringAsFixed(1),
//                                             style: GoogleFonts.dmSans(
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: height * 0.009),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'INR ${(item['price'] * quantity).toStringAsFixed(2)}',
//                                             style: GoogleFonts.dmSans(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Row(
//                                             children: [
//                                               Container(
//                                                 height: height * 0.03,
//                                                 width: width * 0.06,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(4),
//                                                   color: Colorclass.whitecolor,
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colorclass
//                                                           .shadowcolor,
//                                                       offset: const Offset(
//                                                         3,
//                                                         3,
//                                                       ),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 3,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Center(
//                                                   child: IconButton(
//                                                     padding: EdgeInsets.zero,
//                                                     icon: Icon(
//                                                       Icons.remove,
//                                                       size: height * 0.02,
//                                                     ),
//                                                     onPressed: () => ref
//                                                         .read(
//                                                           cartProvider.notifier,
//                                                         )
//                                                         .updateQuantity(
//                                                           item['id'],
//                                                           quantity - 1,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: width * 0.007),
//                                               Container(
//                                                 height: height * 0.03,
//                                                 width: width * 0.06,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(4),
//                                                   color: Colorclass.whitecolor,
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colorclass
//                                                           .shadowcolor,
//                                                       offset: const Offset(
//                                                         3,
//                                                         3,
//                                                       ),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 3,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     quantity.toString(),
//                                                     style: GoogleFonts.dmSans(
//                                                       fontSize: 10,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: width * 0.01),
//                                               Container(
//                                                 height: height * 0.03,
//                                                 width: width * 0.06,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(4),
//                                                   color: Colorclass.whitecolor,
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colorclass
//                                                           .shadowcolor,
//                                                       offset: const Offset(
//                                                         3,
//                                                         3,
//                                                       ),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 3,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Center(
//                                                   child: IconButton(
//                                                     padding: EdgeInsets.zero,
//                                                     icon: Icon(
//                                                       Icons.add,
//                                                       size: height * 0.02,
//                                                     ),
//                                                     onPressed: () => ref
//                                                         .read(
//                                                           cartProvider.notifier,
//                                                         )
//                                                         .updateQuantity(
//                                                           item['id'],
//                                                           quantity + 1,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: height * 0.006,
//                           right: width * 0.013,
//                           child: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => ref
//                                 .read(cartProvider.notifier)
//                                 .removeItem(item['id']),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border(top: BorderSide(color: Colors.grey.shade300)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total:',
//                       style: GoogleFonts.dmSans(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'INR ${total.toStringAsFixed(2)}',
//                       style: GoogleFonts.dmSans(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
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
      backgroundColor: AppColors.background,
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    log('🛍️ Building cart item $index: ${item['name']}');
                    return InkWell(
                      onTap: () {
                        context.pushNamed(
                          'product',
                          pathParameters: {'id': item['name'].toString()},
                          extra: item,
                        );
                      },
                      child: _buildCartItem(context, ref, height, width, item),
                    );
                  },
                ),
              ),
              _buildTotalSection(total, context, items),
            ],
          );
        },
      ),
    );
  }

  // Build iOS-style app bar
  // ignore: strict_top_level_inference
  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'My Cart',
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
      leading: IconButton(
        icon: Icon(Iconsax.arrow_left, color: AppColors.primaryDark),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Iconsax.trash, color: AppColors.primaryDark),
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
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Loading your cart...',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Build error state
  // ignore: strict_top_level_inference
  Widget _buildErrorState(error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Error loading cart items',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
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
          Icon(Iconsax.shopping_cart, size: 64, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some delicious items to get started',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Build cart item card
  Widget _buildCartItem(
    BuildContext context,
    WidgetRef ref,
    double height,
    double width,
    Map<String, dynamic> item,
  ) {
    final hasImage = item['image'] != null;
    final rating = item['rating'] ?? 0.0;
    final quantity = item['quantity'] ?? 1;
    final itemPrice = item['price'] * quantity;
    log('$item');
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 8),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: height * 0.12,
                    width: width * 0.22,
                    color: AppColors.primaryLight,
                    child: hasImage
                        ? Image.asset(
                            item['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _buildItemImagePlaceholder(),
                          )
                        : _buildItemImagePlaceholder(),
                  ),
                ),
                SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        item['name'] ?? 'Unnamed Item',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),

                      // Rating
                      _buildItemRating(rating),
                      SizedBox(height: 8),

                      // Price and Quantity Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${itemPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
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

          // Delete Button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Iconsax.trash, size: 20, color: Colors.red),
              onPressed: () =>
                  ref.read(cartProvider.notifier).removeItem(item['id']),
            ),
          ),
        ],
      ),
    );
  }

  // Build item rating
  Widget _buildItemRating(double rating) {
    return Row(
      children: [
        ...List.generate(5, (starIndex) {
          IconData icon;
          if (starIndex < rating.floor()) {
            icon = Iconsax.star1;
          } else if (starIndex == rating.floor() && rating % 1 >= 0.5) {
            icon = Iconsax.star;
          } else {
            icon = Iconsax.star;
          }
          return Icon(icon, color: Colors.amber, size: 14);
        }),
        SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.textSecondary,
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
      height: 28, // Fixed height
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Important: don't expand
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out evenly
        children: [
          // Decrease button
          SizedBox(
            width: 24, // Fixed width for button
            child: IconButton(
              onPressed: () {
                if (quantity > 1) {
                  ref
                      .read(cartProvider.notifier)
                      .updateQuantity(item['id'], quantity - 1);
                }
              },
              icon: Icon(
                Iconsax.minus,
                size: 12,
                color: quantity > 1
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 24,
                maxWidth: 24,
                minHeight: 24,
                maxHeight: 24,
              ),
            ),
          ),

          // Quantity display - centered with fixed width
          Container(
            width: 20, // Fixed width for quantity
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),

          // Increase button
          SizedBox(
            width: 24, // Fixed width for button
            child: IconButton(
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .updateQuantity(item['id'], quantity + 1);
              },
              icon: Icon(Iconsax.add, size: 12, color: AppColors.primary),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 24,
                maxWidth: 24,
                minHeight: 24,
                maxHeight: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build item image placeholder
  Widget _buildItemImagePlaceholder() {
    return Center(
      child: Icon(
        Iconsax.coffee,
        size: 32,
        // ignore: deprecated_member_use
        color: AppColors.primary.withOpacity(0.3),
      ),
    );
  }

  // Build total section with checkout button
  Widget _buildTotalSection(
    double total,
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.lightBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _proceedToCheckout(context, total, items);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.wallet, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Proceed to Checkout',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    context.push('/checkout', extra: {'total': total, 'items': items});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to checkout with ${items.length} items'),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}

// Define a color palette for the app
class AppColors {
  static const Color primary = Color(0xFFC67C4E);
  static const Color primaryDark = Color(0xFF372213);
  static const Color primaryLight = Color(0xFFFFF5EE);
  static const Color accent = Color(0xFF36C07E);
  static const Color background = Color(0xFFF9F9F9);
  static const Color textPrimary = Color(0xFF2F2D2C);
  static const Color textSecondary = Color(0xFF9B9B9B);
  static const Color lightBorder = Color(0xFFEAEAEA);
}
