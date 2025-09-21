import 'package:coffee_shop/Features/Profile/Provider/voucher_provider.dart';
import 'package:coffee_shop/Features/Profile/data/voucher_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class GiveVoucherScreen extends ConsumerWidget {
  const GiveVoucherScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voucherData = ref.watch(voucherCategoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give Voucher'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: voucherData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading vouchers',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.refresh(voucherCategoriesProvider),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (vouchers) {
          if (vouchers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No vouchers available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Vouchers',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap on any voucher to share it',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      return _buildVoucherCard(context, ref, voucher);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoucherCard(
    BuildContext context,
    WidgetRef ref,
    VoucherProduct voucher,
  ) {
    // Watch the validity of this specific voucher
    final voucherValidity = ref.watch(
      voucherValidityProvider(voucher.voucherId!),
    );
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _shareVoucher(context, voucher),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade100, Colors.blue.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Voucher Icon/Image
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                backgroundImage: voucher.imageUrl.isNotEmpty
                    ? NetworkImage(voucher.imageUrl)
                    : null,
                child: voucher.imageUrl.isEmpty
                    ? const Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              // Offer Percentage
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${voucher.offerPercentage}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Voucher Validity Status
              voucherValidity.when(
                loading: () => const SizedBox(
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const Text(
                  'Check Failed',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                data: (isValid) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isValid ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isValid ? '✓ Valid' : '✗ Invalid',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Voucher ID
              Text(
                voucher.voucherId ?? 'No ID',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontFamily: 'monospace',
                ),
              ),
              // Share Button
              const SizedBox(height: 4),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // Icon(Icons.share, size: 14, color: Colors.blue),
              //     SizedBox(width: 2),
              //     // Text(
              //     //   'Tap to share',
              //     //   style: TextStyle(fontSize: 10, color: Colors.blue),
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareVoucher(BuildContext context, VoucherProduct voucher) {
    final shareText =
        '''
🎉 Special Offer! 🎉

Get ${voucher.offerPercentage}% OFF on ${voucher.category}!

Use voucher code: ${voucher.voucherId}

Valid until: ${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]}

Enjoy your discount! 🎊
''';
    // ignore: deprecated_member_use
    Share.share(
      shareText,
      subject:
          '${voucher.offerPercentage}% OFF Voucher for ${voucher.category}',
    );
  }
}

// Usage: Navigate to this screen
void navigateToGiveVoucherScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ProviderScope(child: GiveVoucherScreen()),
    ),
  );
}
