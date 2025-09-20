import 'dart:developer';
import 'package:coffee_shop/Features/Menu/Provider/favorite_provider.dart';
import 'package:coffee_shop/Features/Menu/Provider/paymentProvider.dart';
import 'package:coffee_shop/Features/Profile/Provider/voucher_provider.dart';
// import 'package:coffee_shop/Features/Profile/Provider/order_provider.dart';
// import 'package:coffee_shop/Features/Profile/Provider/scratch_provider.dart';
// import 'package:coffee_shop/Features/Profile/data/order_model.dart';
// import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:scratcher/widgets.dart';

final quantityProvider = StateProvider<int>((ref) => 1);

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  

   bool _isFavorite = false;
  bool _isLoading = false;
 
   late num price;
  late int quantity;
  late num totalPrice;
  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    log('${user?.phoneNumber}');
      final appliedVoucherId = ref.watch(appliedVoucherIdProvider);
  final voucherDiscount = ref.watch(voucherDiscountProvider);
  
    ref.listen<PaymentState>(paymentProvider, (previous, next) {
      log('Payment State Changed:');
      log('Previous: ${previous?.paymentSuccess}');
      log('Next: ${next.paymentSuccess}');
      if (next.paymentSuccess && mounted) {
        final paymentData = ref
            .read(paymentProvider.notifier)
            .getLastPaymentData();
        log('paymentdata : $paymentData');
        // log('Showing scratch card first');

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            // Show scratch card and wait for completion
            // final scratchCompleted = await showScratchCardDialog(context);
            //   if (scratchCompleted && mounted) {
            //     log('Scratch completed, navigating to success screen');
            //     // ignore: use_build_context_synchronously
            //     context.push('/payment-success', extra: paymentData);
            //     ref.read(paymentProvider.notifier).clearSuccess();
            //   } else if (mounted) {
            //     log('Scratch was cancelled');
            //     ref.read(paymentProvider.notifier).clearSuccess();
            //   }
            context.push('/payment-success', extra: paymentData);
            ref.read(paymentProvider.notifier).clearSuccess();
          }
        });
      }
    });

    final quantity = ref.watch(quantityProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
 // CALCULATE PRICES USING PROVIDER VALUES:
    final product = widget.product;
    final price = product['price'] != null
        ? (product['price'] is num
              ? product['price'] as num
              : (double.tryParse(product['price'].toString()) ?? 0.0))
        : 0.0;
    final totalPrice = price * quantity;
    final discountAmount = (price * quantity * voucherDiscount / 100);
  final finalPrice = (price * quantity) - discountAmount;

    log('starting product :$product');

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: _buildAppBar(
        context,
        product['name'] ?? 'Product Details',
        colorScheme,
        textTheme,
        _isFavorite
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with iOS-style design
            _buildProductImage(
              MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width,
              ref,
              product,
              colorScheme,
              textTheme,
            ),
            const SizedBox(height: 24),

            // Product Name and Rating
            _buildProductHeader(
              context,
              ref,
              MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width,
              quantity,
              price,
              product,
              colorScheme,
              textTheme,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Price Section
            _buildPriceSection(price, totalPrice, discountAmount, finalPrice, colorScheme, textTheme),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildVoucherSection(
            context,
            ref,
            totalPrice.toDouble(),
            colorScheme,
            textTheme,
          ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Description (if available)
            if (product['description'] != null)
              _buildDescriptionSection(
                MediaQuery.of(context).size.height,
                product,
                colorScheme,
                textTheme,
              ),

            // Add to Cart Button
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
             _buildCheckoutButton(
            context,
            ref,
            product,
            quantity,
            price,
            finalPrice,   // Use final price instead of totalPrice
            colorScheme,
            textTheme,
          ),
          ],
        ),
      ),
    );
  }
  Future<void> _checkFavoriteStatus() async {
    setState(() => _isLoading = true);
    try {
      final isFav = await ref
          .read(favoritesProvider.notifier)
          .isFavorite(widget.product['name']);
      setState(() => _isFavorite = isFav);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(favoritesProvider.notifier)
          .toggleFavorite(widget.product);
      setState(() => _isFavorite = !_isFavorite);
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // String _generateRandomReward() {
  //   final rewards = [
  //     '10% Off Your Next Order',
  //     'Free Coffee',
  //     '20% Off Premium Blends',
  //     'Buy One Get One Free',
  //     'Free Pastry with Purchase',
  //     '15% Off All Items',
  //     'Free Delivery on Next Order'
  //   ];

  //   return rewards[DateTime.now().millisecond % rewards.length];
  // }
  // Future<void> _saveOrderToFirebase(
  //   WidgetRef ref,
  //   Map<String, dynamic> product,
  //   int quantity,
  //   double totalPrice,
  // ) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null || user.phoneNumber == null) {
  //       throw Exception('User not authenticated');
  //     }

  //     // Create OrderItem
  //     final order = OrderItem(
  //       userId: user.uid,
  //       imagePath: product['image'] ?? '',
  //       name: product['name'] ?? 'Unknown Product',
  //       rating: (product['rating'] is num ? product['rating'].toDouble() : 0.0),
  //       quantity: quantity.toDouble(),
  //       total: totalPrice.toDouble(),
  //       unitPrice: (product['price'] is num ? product['price'].toDouble() : 0.0),
  //       productId: product['id']?.toString(),
  //     );

  //     // Save using the provider
  //     await ref.read(orderProvider.notifier).addOrder(order);
  //     log('Order saved successfully: ${order.name}');
  //   } catch (e) {
  //     log('Error saving order: $e');
  //     throw Exception('Failed to save order: $e');
  //   }
  // }

  // Future<bool> showScratchCardDialog(BuildContext context) async {
  // final scratchCardsNotifier = ref.read(scratchCardsProvider.notifier);
  // final newScratchCard = ScratchCardModel(
  //   isScratched: false,
  //   createdAt: DateTime.now(),
  //   reward: _generateRandomReward(),
  //   imagePath: 'Assets/Images/scratch1.jpg',
  // );
  //   return await showDialog<bool>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext dialogContext) {
  //           log('in scratch cart');
  //           return AlertDialog(
  //             contentPadding: EdgeInsets.zero,
  //             content: SizedBox(
  //               height: 300,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.only(top: 16.0),
  //                     child: Text(
  //                       'Scratch to reveal your reward!',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Container(
  //                       height: 180,
  //                       width: 200,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(20),
  //                         color: Colors.amber,
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.grey.withOpacity(0.5),
  //                             spreadRadius: 2,
  //                             blurRadius: 5,
  //                             offset: const Offset(0, 3),
  //                           ),
  //                         ],
  //                       ),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(20),
  //                         child: Scratcher(
  //                           brushSize: 70,
  //                           threshold: 50,
  //                           color: Colors.pink,
  //                           onScratchEnd: () async {
  //                         log("✅ Scratch finished!");
  //                       final updatedCard = newScratchCard.copyWith(
  //                         isScratched: true,
  //                       );
  //                       await scratchCardsNotifier.addScratchCard(updatedCard);
  //                       // ignore: use_build_context_synchronously
  //                       Navigator.of(dialogContext).pop(true);
  //                           },
  //                           child: Center(
  //                             child: Image(
  //                               image: AssetImage('Assets/Images/scratch1.jpg'),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   TextButton(
  //                     onPressed: ()async {
  //                     log("⏩ Skip tapped.");
  //                 await scratchCardsNotifier.addScratchCard(newScratchCard);
  //                 // ignore: use_build_context_synchronously
  //                 Navigator.of(dialogContext).pop(true);
  //                     },
  //                     child: Text('Skip'),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ) ??
  //       false;
  // }

  // Build iOS-style app bar
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    String title,
    ColorScheme colorscheme,
    TextTheme texttheme,
    bool isFavorite,
  ) {
    return AppBar(
      backgroundColor: colorscheme.surface,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: texttheme.titleLarge?.copyWith(
          color: colorscheme.primaryContainer,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        // color: colorScheme.primaryContainer, fontWeight: FontWeight.w400,fontSize: 14
      ),
      leading: IconButton(
        icon: Icon(Iconsax.arrow_left, color: colorscheme.primary),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          color: isFavorite 
              ? Colors.red 
              : colorscheme.secondaryFixed,
        ),
        onPressed: () async {
          await _toggleFavorite();
        },
      ),
      ],
    );
  }

  // Build product image section
  Widget _buildProductImage(
    double height,
    double width,
    ref,
    Map<String, dynamic> product,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return Container(
      height: height * 0.32,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorscheme.onSecondaryFixed,
        boxShadow: [
          BoxShadow(
            color: colorscheme.shadow,
            offset: Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: product['image'] != null
            ? Image.network(
                product['image'],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildImagePlaceholder(colorscheme),
              )
            : _buildImagePlaceholder(colorscheme),
      ),
    );
  }

  // Build image placeholder
  Widget _buildImagePlaceholder(ColorScheme colorscheme) {
    return Center(
      child: Icon(
        Iconsax.coffee,
        size: 60,
        // ignore: deprecated_member_use
        color: colorscheme.secondaryFixed.withOpacity(0.3),
      ),
    );
  }

  // Build product header with name, rating, and quantity controls
  Widget _buildProductHeader(
    BuildContext context,
    WidgetRef ref,
    double height,
    double width,
    int quantity,
    num price,
    Map<String, dynamic> product,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          product['name'] ?? 'No Name',
          style: texttheme.bodyLarge?.copyWith(
            color: colorscheme.primaryContainer,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: height * 0.01),

        // Rating and Quantity Controls
        Row(
          children: [
            // Rating
            _buildRatingStars(product, colorscheme, texttheme),
            SizedBox(width: 8),
            Text(
              (product['rating']?.toStringAsFixed(1) ?? '0.0'),
              style: texttheme.titleMedium?.copyWith(
                color: colorscheme.secondary,
              ),
            ),
            Spacer(),
            // Quantity Controls
            _buildQuantityControls(
              ref,
              height,
              width,
              quantity,
              colorscheme,
              texttheme,
            ),
          ],
        ),
      ],
    );
  }

  // Build rating stars
  Widget _buildRatingStars(
    Map<String, dynamic> product,
    colorscheme,
    texttheme,
  ) {
    return Row(
      children: List.generate(5, (index) {
        IconData icon;
        if (index < (product['rating']?.floor() ?? 0)) {
          icon = Iconsax.star1;
        } else if (index == (product['rating']?.floor() ?? 0) &&
            (product['rating'] ?? 0) % 1 >= 0.5) {
          icon = Iconsax.star;
        } else {
          icon = Iconsax.star;
        }
        return Icon(icon, color: colorscheme.onPrimaryFixed, size: 20);
      }),
    );
  }

  // Build quantity controls
  Widget _buildQuantityControls(
    WidgetRef ref,
    double height,
    double width,
    int quantity,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorscheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorscheme.shadow),
      ),
      child: Row(
        children: [
          // Decrease button
          IconButton(
            onPressed: () {
              if (quantity > 1) {
                ref.read(quantityProvider.notifier).state--;
                log('Item count: ${quantity - 1}');
              }
            },
            icon: Icon(
              Iconsax.minus,
              size: 20,
              color: quantity > 1
                  ? colorscheme.secondaryFixed
                  : colorscheme.secondary,
            ),
            splashRadius: 20,
          ),

          // Quantity display
          SizedBox(
            width: width * 0.08,
            child: Center(
              child: Text(
                "$quantity",
                style: texttheme.labelMedium?.copyWith(
                  color: colorscheme.primaryContainer,
                ),
              ),
            ),
          ),

          // Increase button
          IconButton(
            onPressed: () {
              ref.read(quantityProvider.notifier).state++;
              log('Item count: ${quantity + 1}');
            },
            icon: Icon(
              Iconsax.add,
              size: 20,
              color: colorscheme.secondaryFixed,
            ),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  // Build price section
  Widget _buildPriceSection(
    num price,
    num totalPrice,
    num discountAmount,
    num finalPrice,
    ColorScheme colorscheme,
    TextTheme texttheme,

  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorscheme.onSecondaryFixed,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorscheme.shadow,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing Details',
            style: texttheme.bodyMedium?.copyWith(
              color: colorscheme.primary,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Unit Price:',
          //       style: texttheme.bodySmall?.copyWith(
          //         color: colorscheme.secondary,
          //         fontSize: 12,
          //       ),
          //     ),
          //     Text(
          //       '₹${price.toStringAsFixed(2)}',
          //       style: texttheme.bodyMedium?.copyWith(
          //         color: colorscheme.primary,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 8),
          // Divider(height: 1, color: colorscheme.shadow),
          // SizedBox(height: 8),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Total:',
          //       style: texttheme.bodySmall?.copyWith(
          //         color: colorscheme.primary,
          //         fontSize: 11,
          //       ),
          //     ),
          //     Text(
          //       '₹${totalPrice.toStringAsFixed(2)}',
          //       style: texttheme.bodyMedium?.copyWith(
          //         color: colorscheme.secondaryFixed,
          //       ),
          //     ),
          //     if (_voucherDiscount > 0) ...[
          //       SizedBox(height: 8),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Discount (${_voucherDiscount}%):',
          //             style: texttheme.bodySmall?.copyWith(
          //               color: Colors.green,
          //               fontSize: 12,
          //             ),
          //           ),
          //           Text(
          //             '-₹${discountAmount.toStringAsFixed(2)}',
          //             style: texttheme.bodyMedium?.copyWith(
          //               color: Colors.green,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ],
          // ),
           Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Unit Price:',
              style: texttheme.bodySmall?.copyWith(
                color: colorscheme.secondary,
                fontSize: 12,
              ),
            ),
            Text(
              '₹${price.toStringAsFixed(2)}',
              style: texttheme.bodyMedium?.copyWith(
                color: colorscheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        
          // Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity:',
                style: texttheme.bodySmall?.copyWith(
                  color: colorscheme.secondary,
                  fontSize: 12,
                ),
              ),
              Text(
                quantity.toString(),
                style: texttheme.bodyMedium?.copyWith(
                  color: colorscheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: texttheme.bodySmall?.copyWith(
                  color: colorscheme.secondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '₹${totalPrice.toStringAsFixed(2)}',
                style: texttheme.bodyMedium?.copyWith(
                  color: colorscheme.primary,
                ),
              ),
            ],
          ),

          // Discount if applied
          if (voucherDiscount > 0) ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount (${voucherDiscount}%):',
                  style: texttheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '-₹${discountAmount.toStringAsFixed(2)}',
                  style: texttheme.bodyMedium?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ],

          SizedBox(height: 8),
          Divider(height: 1, color: colorscheme.shadow),
          SizedBox(height: 8),

          // Final Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: texttheme.bodySmall?.copyWith(
                color: colorscheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₹${finalPrice.toStringAsFixed(2)}',
              style: texttheme.bodyMedium?.copyWith(
                color: colorscheme.secondaryFixed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }

  // Build description section
  Widget _buildDescriptionSection(
    double height,
    Map<String, dynamic> product,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorscheme.onSecondaryFixed,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorscheme.shadow,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: texttheme.bodyMedium?.copyWith(
              color: colorscheme.primary,
              fontSize: 13,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            product['description'],
            style: texttheme.bodySmall?.copyWith(
              color: colorscheme.secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Build checkout button
  Widget _buildCheckoutButton(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> product,
    int quantity,
    num price,
    num finalPrice,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final user = FirebaseAuth.instance.currentUser;
          log('phone number suru :$user.phoneNumber');
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please log in before making a payment"),
                margin: EdgeInsets.all(16),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            );
            return;
          } else {
            _handleCheckout(context, ref, product, quantity, price,  finalPrice);
          }
          // context.push('/payment-method');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorscheme.onPrimaryFixedVariant,
          foregroundColor: colorscheme.onSecondaryFixed,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          // ignore: deprecated_member_use
          shadowColor: colorscheme.shadow.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.shopping_cart,
              size: 20,
              color: colorscheme.onSecondaryFixed,
            ),
            SizedBox(width: 8),
            Text(
              'Proceed to Checkout ($quantity items)₹ ${finalPrice.toStringAsFixed(2)}',
              style: texttheme.bodySmall?.copyWith(
                color: colorscheme.onSecondaryFixed,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCheckout(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> product,
    int quantity,
    num price,
    num finalPrice,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    log('User: ${user?.uid}');
    log('Phone: ${user?.phoneNumber}');
    log('=== Checkout Details ===');
    log('Total Items: ${product.length}');
    log('Total Price: ₹${totalPrice.toStringAsFixed(2)}');
    
  final voucherDiscount = ref.read(voucherDiscountProvider);
  final appliedVoucherId = ref.read(appliedVoucherIdProvider);
  final discountAmount = (price * quantity * voucherDiscount / 100);
  
  // THEN USE THESE IN YOUR LOGS:
  if (voucherDiscount > 0) {
    log('Voucher: $appliedVoucherId');
    log('Discount: ${voucherDiscount}% (₹${discountAmount.toStringAsFixed(2)})');
  }

    if (user == null || user.phoneNumber == null) {
      log('User not authenticated with phone number');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login with your phone number before making a payment.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      context.push('/login-screen');
      return;
    }

    final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';

    log('=== Checkout Details ===');
    log('Product: ${product['name']}');
    log('Quantity: $quantity');
    log('Unit Price: ₹${price.toStringAsFixed(2)}');
    log('Total Price: ₹${finalPrice.toStringAsFixed(2)}');

    try {
      log('Initiating payment...');
      await ref
          .read(paymentProvider.notifier)
          .initiatePayment(
            amount: finalPrice,
            productName: product['name'],
            quantity: quantity,
            orderId: orderId,
          );
      // .initiatePayment(amount: totalPrice, productName: product['name'], quantity: quantity, orderId: orderId);

      // await _saveOrderToFirebase(ref, product, quantity, totalPrice.toDouble());  //use for save to firebase recent order with data
    } catch (e) {
      log('Payment initiation error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    log('=======================');
  }
}

Future<void> _applyVoucher(WidgetRef ref,BuildContext context) async {
  final voucherController = ref.read(voucherControllerProvider);
  final voucherId = voucherController.text.trim();
  
  if (voucherId.isEmpty) {
    ref.read(voucherErrorProvider.notifier).state = 'Please enter a voucher code';
    return;
  }

  ref.read(isCheckingVoucherProvider.notifier).state = true;
  ref.read(voucherErrorProvider.notifier).state = null;

  try {
    final discount = await ref.read(voucherValidationProvider(voucherId).future);
    
    if (discount != null && discount > 0) {
      ref.read(appliedVoucherIdProvider.notifier).state = voucherId;
      ref.read(voucherDiscountProvider.notifier).state = discount;
      ref.read(voucherErrorProvider.notifier).state = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$discount% discount applied successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ref.read(voucherErrorProvider.notifier).state = 'Invalid or expired voucher code';
      ref.read(appliedVoucherIdProvider.notifier).state = null;
      ref.read(voucherDiscountProvider.notifier).state = 0.0;
    }
  } catch (e) {
    ref.read(voucherErrorProvider.notifier).state = 'Error validating voucher: $e';
    ref.read(appliedVoucherIdProvider.notifier).state = null;
    ref.read(voucherDiscountProvider.notifier).state = 0.0;
  } finally {
    ref.read(isCheckingVoucherProvider.notifier).state = false;
  }
}
void _removeVoucher(WidgetRef ref,BuildContext context) {
  ref.read(appliedVoucherIdProvider.notifier).state = null;
  ref.read(voucherDiscountProvider.notifier).state = 0.0;
  ref.read(voucherControllerProvider).clear();
  ref.read(voucherErrorProvider.notifier).state = null;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Voucher removed'),
      backgroundColor: Colors.blue,
    ),
  );
}
// Build voucher code section
Widget _buildVoucherSection(
  BuildContext context,
  WidgetRef ref,
  double totalPrice,
  ColorScheme colorscheme,
  TextTheme texttheme,
) {
   final voucherController = ref.watch(voucherControllerProvider);
  final appliedVoucherId = ref.watch(appliedVoucherIdProvider);
  final voucherDiscount = ref.watch(voucherDiscountProvider);
  final isCheckingVoucher = ref.watch(isCheckingVoucherProvider);
  final voucherError = ref.watch(voucherErrorProvider);
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colorscheme.onSecondaryFixed,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: colorscheme.shadow,
          offset: Offset(0, 4),
          blurRadius: 8,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apply Voucher',
          style: texttheme.bodyMedium?.copyWith(
            color: colorscheme.primary,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 12),
        
        // Voucher Input Field
        TextField(
          controller: voucherController,
          decoration: InputDecoration(
            hintText: 'Enter voucher code',
            suffixIcon: isCheckingVoucher
                ? CircularProgressIndicator(strokeWidth: 2)
                : IconButton(
                    icon: Icon(Icons.discount),
                    onPressed: () => _applyVoucher(ref,context),
                  ),
            errorText: voucherError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (_) => _applyVoucher(ref,context),
        ),
        
        SizedBox(height: 8),
        
        // Voucher Status
        if (appliedVoucherId != null)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Voucher Applied:',
                    style: texttheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    appliedVoucherId,
                    style: texttheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount:',
                    style: texttheme.bodySmall?.copyWith(
                      color: colorscheme.secondary,
                    ),
                  ),
                  Text(
                    '${voucherDiscount.toStringAsFixed(1)}% OFF',
                    style: texttheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _removeVoucher(ref,context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text('Remove Voucher'),
              ),
            ],
          ),
        
        // Discount Amount Display
        if (voucherDiscount > 0)
          Column(
            children: [
              SizedBox(height: 12),
              Divider(height: 1, color: colorscheme.shadow),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You Save:',
                    style: texttheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '₹${(totalPrice * voucherDiscount / 100).toStringAsFixed(2)}',
                    style: texttheme.bodyMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    ),
  );
}

// Define a color palette for the app
