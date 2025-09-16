import 'dart:developer';
import 'package:coffee_shop/Features/Menu/Provider/paymentProvider.dart';
import 'package:coffee_shop/Features/Profile/Provider/scratch_provider.dart';
import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:scratcher/widgets.dart';

final quantityProvider = StateProvider<int>((ref) => 1);


class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser;
    log('${user?.phoneNumber}');
    ref.listen<PaymentState>(paymentProvider, (previous, next) {
      log('Payment State Changed:');
      log('Previous: ${previous?.paymentSuccess}');
      log('Next: ${next.paymentSuccess}');
      if (next.paymentSuccess && mounted) {
        final paymentData = ref
            .read(paymentProvider.notifier)
            .getLastPaymentData();
        log('paymentdata : $paymentData');
        log('Showing scratch card first');

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            // Show scratch card and wait for completion
            final scratchCompleted = await showScratchCardDialog(context);
            if (scratchCompleted && mounted) {
              log('Scratch completed, navigating to success screen');
              // ignore: use_build_context_synchronously
              context.push('/payment-success', extra: paymentData);
              ref.read(paymentProvider.notifier).clearSuccess();
            } else if (mounted) {
              log('Scratch was cancelled');
              ref.read(paymentProvider.notifier).clearSuccess();
            }
          }
        });
      }
    });

    final quantity = ref.watch(quantityProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final product = widget.product;
    final price = product['price'] != null
        ? (product['price'] is num
              ? product['price'] as num
              : (double.tryParse(product['price'].toString()) ?? 0.0))
        : 0.0;
    final totalPrice = price * quantity;
    log('starting product :$product');

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: _buildAppBar(
        context,
        product['name'] ?? 'Product Details',
        colorScheme,
        textTheme,
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
            _buildPriceSection(price, totalPrice, colorScheme, textTheme),
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
              totalPrice,
              colorScheme,
              textTheme,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showScratchCardDialog(BuildContext context) async {
     final scratchCardsNotifier = ref.read(scratchCardsProvider.notifier);
  
  // Create a new scratch card
  final newScratchCard = ScratchCardModel(
    isScratched: false,
    createdAt: DateTime.now(),
    reward: 'Special Discount',
    imagePath: 'Assets/Images/scratch1.jpg',
     // You can customize this
  );
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            log('in scratch cart');
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Scratch to reveal your reward!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 180,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Scratcher(
                            brushSize: 70,
                            threshold: 50,
                            color: Colors.pink,
                            onScratchEnd: () async {
                          log("✅ Scratch finished!");
                        final updatedCard = newScratchCard.copyWith(
                          isScratched: true,
                        );
                        await scratchCardsNotifier.addScratchCard(updatedCard);
                        // ignore: use_build_context_synchronously
                        Navigator.of(dialogContext).pop(true);
                            },
                            child: Center(
                              child: Image(
                                image: AssetImage('Assets/Images/scratch1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: ()async {
                      log("⏩ Skip tapped.");
                  await scratchCardsNotifier.addScratchCard(newScratchCard);
                  Navigator.of(dialogContext).pop(true);
                      },
                      child: Text('Skip'),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  // Build iOS-style app bar
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    String title,
    ColorScheme colorscheme,
    TextTheme texttheme,
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
          icon: Icon(Iconsax.heart, color: colorscheme.secondaryFixed),
          onPressed: () {},
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
          Divider(height: 1, color: colorscheme.shadow),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: texttheme.bodySmall?.copyWith(
                  color: colorscheme.primary,
                  fontSize: 11,
                ),
              ),
              Text(
                '₹${totalPrice.toStringAsFixed(2)}',
                style: texttheme.bodyMedium?.copyWith(
                  color: colorscheme.secondaryFixed,
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
    num totalPrice,
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
            _handleCheckout(context, ref, product, quantity, price, totalPrice);
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
              'Proceed to Checkout ($quantity items)',
              style: texttheme.bodySmall?.copyWith(
                color: colorscheme.onSecondaryFixed,
                fontSize: 12,
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
    num totalPrice,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    log('User: ${user?.uid}');
    log('Phone: ${user?.phoneNumber}');

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
    log('Total Price: ₹${totalPrice.toStringAsFixed(2)}');

    try {
      log('Initiating payment...');

      await ref
          .read(paymentProvider.notifier)
          .initiatePayment(
            amount: totalPrice,
            productName: product['name'],
            quantity: quantity,
            orderId: orderId,
          );

      log('Payment initiated successfully');
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

// Define a color palette for the app
