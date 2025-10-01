// features/Event/presentation/user_bookings_screen.dart
import 'package:coffee_shop/Authentication/provider/current_user.dart';
import 'package:coffee_shop/Features/Event/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserBookingsScreen extends ConsumerWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userBookings = ref.watch(userBookingsProvider(currentUser?.uid ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: userBookings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'No bookings found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildBookingCard(booking, context);
            },
          );
        },
      ),
    );
  }

  // ignore: strict_top_level_inference
  Widget _buildBookingCard(booking, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              _buildStatusIcon(booking.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.eventType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatDate(booking.selectedDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(booking.status),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Booking Details
          _buildDetailRow('Time', 
            '${booking.selectedTime.format(context)} - ${booking.endingTime.format(context)}'
          ),
          _buildDetailRow('Guests', '${booking.numberOfGuests} people'),
          _buildDetailRow('Category', _getCategoryName(booking.categoryId)),
          
          if (booking.specialRequests?.isNotEmpty == true) ...[
            _buildDetailRow('Special Requests', booking.specialRequests!),
          ],
          
          // Admin Response (if available)
          if (booking.status != 'pending' && booking.adminResponse?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: _getStatusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: _getStatusColor(booking.status).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        booking.status == 'approved'
                          ? Icons.check_circle
                          : Icons.info,
                        color: _getStatusColor(booking.status),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        booking.status == 'approved'
                          ? 'Approved!' 
                          : 'Admin Response',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(booking.status),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.adminResponse!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondaryFixed,
                    ),
                  ),
                ],
              ),
            ),
        ],
          if (booking.additionalOptions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Additional Services:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            _buildAdditionalOptions(booking.additionalOptions, context),
          ],
        ],
      ),
    ),
  );
}
Widget _buildAdditionalOptions(Map<String, dynamic> additionalOptions, BuildContext context) {
  final enabledOptions = additionalOptions.entries
      .where((entry) => entry.value == true)
      .toList();

  if (enabledOptions.isEmpty) {
    return const SizedBox.shrink();
  }

  return Wrap(
    spacing: 8,
    runSpacing: 4,
    children: enabledOptions.map((entry) {
      return Chip(
        label: Text(_formatOptionName(entry.key)),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 12,
        ),
      );
    }).toList(),
  );
}

  Widget _buildStatusIcon(String status) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: _getStatusColor(status).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getStatusIcon(status),
        color: _getStatusColor(status),
        size: 20,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.pending_actions;
      default:
        return Icons.pending;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  String _getCategoryName(String categoryId) {
    // You'll need to import your categories provider or define this method
    final categories = {
      'private': 'Private Celebration',
      'music': 'Live Music & Open Mic',
      'workshop': 'Workshop & Meeting',
      'corporate': 'Corporate Event',
    };
    return categories[categoryId] ?? 'Unknown Category';
  }

  String _formatOptionName(String key) {
    return key
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ')
        .trim();
  }
}