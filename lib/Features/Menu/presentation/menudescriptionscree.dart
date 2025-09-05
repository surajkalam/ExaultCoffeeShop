// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coffee_shop/Cores/Widget/favoriteIcon.dart';
// import 'package:coffee_shop/Cores/utils/helper.dart';
// import 'package:coffee_shop/DATABASE_HELPER/cart_data.dart';
// import 'package:coffee_shop/Features/Cart/provider/cart_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CategoryItemsScreen extends ConsumerWidget {
//   final String categoryName;
//   final List<Map<String, dynamic>> items;

//   const CategoryItemsScreen({
//     super.key,
//     required this.categoryName,
//     required this.items,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     if (items.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: Text(categoryName)),
//         body: const Center(child: Text('No items available')),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(title: Text(categoryName), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.85,
//           ),
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             final item = items[index];
//             log('$item');
//             final hasImage = item['image'] != null;
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: constraints.maxHeight * 0.5,
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: hasImage
//                                   ? Image.asset(
//                                       item['image'],
//                                       height: constraints.maxHeight * 0.5,
//                                       width: double.infinity,
//                                       // width: width*0.4,
//                                       fit: BoxFit.fill,
//                                       errorBuilder: (_, _, _) => Container(
//                                         color: Colors.grey[200],
//                                         child: Icon(
//                                           Icons.fastfood,
//                                           size: width * 0.04,
//                                         ),
//                                       ),
//                                     )
//                                   : Container(
//                                       color: Colors.grey[200],
//                                       child: const Icon(
//                                         Icons.fastfood,
//                                         size: 40,
//                                       ),
//                                     ),
//                             ),
//                             Positioned(
//                               bottom: height*0.001,
//                               right: width*0.01,
//                               child: FavoriteIcon(
//                                 itemData: {
//                                   'name': item['name'] ?? '',
//                                   'type': item['type'] ?? '',
//                                   'rating': item['rating'] ?? 0,
//                                   'image': item['image'] ?? '',
//                                   'description': item['description'] ?? '',
//                                   'price': item['price'] ?? 0,
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8.0,
//                           vertical: 4,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: constraints.maxHeight * 0.1,
//                               child: Text(
//                                 item['name'] ?? 'No Name',
//                                 style: GoogleFonts.dmSans(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.clip,
//                               ),
//                             ),

//                             SizedBox(
//                               height: constraints.maxHeight * 0.1,
//                               child: Row(
//                                 children: [
//                                   ...List.generate(5, (index) {
//                                     IconData icon;
//                                     if (index < (item['rating'] ?? 0).floor()) {
//                                       icon = Icons.star;
//                                     } else if (index ==
//                                             (item['rating'] ?? 0).floor() &&
//                                         (item['rating'] ?? 0) % 1 >= 0.5) {
//                                       icon = Icons.star_half;
//                                     } else {
//                                       icon = Icons.star_border;
//                                     }
//                                     return Icon(
//                                       icon,
//                                       color: Colors.amber,
//                                       size: 12,
//                                     );
//                                   }),
//                                   SizedBox(width: width * 0.03),
//                                   Text(
//                                     (item['rating']?.toStringAsFixed(1) ??
//                                         '0.0'),
//                                     style: GoogleFonts.dmSans(
//                                       fontSize: width * 0.025,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             SizedBox(
//                               height: constraints.maxHeight * 0.14,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'INR ${item['price'] ?? '0'}',
//                                     style: GoogleFonts.dmSans(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () async {
//                                        _addToCart(context,item);

//                                       if (item['name'] == null) {
//                                         ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           SnackBar(
//                                             content: Text(
//                                               'Product name missing',
//                                             ),
//                                           ),
//                                         );
//                                         return;
//                                       }
//                                     },

//                                       try {
//                                         await DatabaseHelper.instance
//                                             .insertCartItem({
//                                               'product_id':
//                                                   item['id'] ?? item['name'],
//                                               'name': item['name'],
//                                               'price': item['price'],
//                                               'quantity': 1,
//                                               'image': item['image'],
//                                               'rating': item['rating'],
//                                             });

//                                         if (context.mounted) {
//                                           final ref = ProviderScope.containerOf(
//                                             context,
//                                           );
//                                           ref.refresh(cartProvider);
//                                         }

//                                         if (context.mounted) {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text('Added to cart'),
//                                             ),
//                                           );
//                                         }

//                                         if (context.mounted) {
//                                           context.pushNamed(
//                                             'product',
//                                             pathParameters: {
//                                               'id': item['name'].toString(),
//                                             },
//                                             extra: item,
//                                           );
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text('Added to cart'),
//                                             ),
//                                           );
//                                         }
//                                       // } catch (e, stack) {
//                                       //   debugPrint(
//                                       //     'Error adding to cart: $e\n$stack',
//                                       //   );
//                                       //   if (context.mounted) {
//                                       //     ScaffoldMessenger.of(
//                                       //       context,
//                                       //     ).showSnackBar(
//                                       //       SnackBar(
//                                       //         content: Text(
//                                       //           'Failed to add to cart: ${e.toString()}',
//                                       //         ),
//                                       //       ),
//                                       //     );
//                                       //   }
//                                       // }
//                                     },
//                                     child: addbutton(height, width),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//   Future<void> _addToCart(BuildContext context,Map<String, dynamic> itemData) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null || user.email == null) {
//         throw Exception('User not logged in');
//       }

//       // Sanitize email for Firestore path
//       final userEmail = user.email!.replaceAll('.', '_');
//       final itemName = itemData['name'];

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userEmail)
//           .collection('cart')
//           .doc(itemName)
//           .set({
//             ...itemData,
//             'quantity': FieldValue.increment(1),
//             'addedAt': FieldValue.serverTimestamp(),
//           }, SetOptions(merge: true));

//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${itemData['name']} added to cart')),
//       );
//     } catch (e) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
//       );
//     }
//   }

// }
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Cores/Widget/favoriteIcon.dart';
import 'package:coffee_shop/DATABASE_HELPER/cart_data.dart';
import 'package:coffee_shop/Features/Cart/provider/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CategoryItemsScreen extends ConsumerWidget {
  final String categoryName;
  final List<Map<String, dynamic>> items;

  const CategoryItemsScreen({
    super.key,
    required this.categoryName,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(categoryName, context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.coffee, size: 60, color: AppColors.textSecondary),
              SizedBox(height: 16),
              Text(
                'No items available',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Check back later for new additions',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(categoryName, context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            log('$item');
            final hasImage = item['image'] != null;

            return _buildProductCard(context, height, width, item, hasImage);
          },
        ),
      ),
    );
  }

  // Build iOS-style app bar
  PreferredSizeWidget _buildAppBar(String title, context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
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
          icon: Icon(Iconsax.search_normal, color: AppColors.primaryDark),
          onPressed: () {},
        ),
      ],
    );
  }

  // Build product card with iOS design
  Widget _buildProductCard(
    BuildContext context,
    double height,
    double width,
    Map<String, dynamic> item,
    bool hasImage,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section
          Stack(
            children: [
              Container(
                height: height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.primaryLight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: hasImage
                      ? Image.asset(
                          item['image'],
                          fit: BoxFit.fill,
                          errorBuilder: (_, _, _) => _buildImagePlaceholder(),
                        )
                      : _buildImagePlaceholder(),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: FavoriteIcon(
                  itemData: {
                    'name': item['name'] ?? '',
                    'type': item['type'] ?? '',
                    'rating': item['rating'] ?? 0,
                    'image': item['image'] ?? '',
                    'description': item['description'] ?? '',
                    'price': item['price'] ?? 0,
                  },
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: _buildRatingBadge(item['rating'] ?? 0),
              ),
            ],
          ),

          // Product Details Section
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  item['name'] ?? 'No Name',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                  // maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Product Description (if available)
                if (item['description'] != null &&
                    item['description'].isNotEmpty)
                  Text(
                    item['description'],
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                SizedBox(height: 3),

                // Price and Add to Cart Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item['price'] ?? '0'}',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _addToCart(context, item);
                          if (context.mounted) {
                            context.pushNamed(
                              'product',
                              pathParameters: {'id': item['name'].toString()},
                              extra: item,
                            );
                          }
                        },
                        child: _buildAddToCartButton(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build rating badge
  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.star1, size: 14, color: Colors.amber),
          SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  // Build add to cart button
  Widget _buildAddToCartButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Iconsax.add, size: 18, color: Colors.white),
    );
  }

  // Build image placeholder
  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Iconsax.coffee,
        size: 40,
        // ignore: deprecated_member_use
        color: AppColors.primary.withOpacity(0.5),
      ),
    );
  }

  // Add to cart function
  Future<void> _addToCart(
    BuildContext context,
    Map<String, dynamic> itemData,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception('User not logged in');
      }

      // Sanitize email for Firestore path
      final userEmail = user.email!.replaceAll('.', '_');
      final itemName = itemData['name'];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('cart')
          .doc(itemName)
          .set({
            ...itemData,
            'quantity': FieldValue.increment(1),
            'addedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      await DatabaseHelper.instance.insertCartItem({
        'product_id': itemData['id'] ?? itemData['name'],
        'name': itemData['name'],
        'price': itemData['price'],
        'quantity': 1,
        'image': itemData['image'],
        'rating': itemData['rating'],
      });

      if (context.mounted) {
        final ref = ProviderScope.containerOf(context);
        ref.refresh(cartProvider);
      }
      // Show success feedback
      // ignore: use_build_context_synchronously
      _showAddToCartSuccess(context, itemData['name']);

      // Refresh cart if needed
      if (context.mounted) {
        final ref = ProviderScope.containerOf(context);
        ref.refresh(cartProvider);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showAddToCartError(context, e.toString());
    }
  }

  // Show success feedback with iOS-style animation
  void _showAddToCartSuccess(BuildContext context, String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName added to cart'),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );

    // Optional: Add haptic feedback for iOS feel
    // HapticFeedback.lightImpact();
  }

  // Show error feedback
  void _showAddToCartError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add to cart: $error'),
        backgroundColor: Colors.red,
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
