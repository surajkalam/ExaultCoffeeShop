// import 'dart:developer';
// import 'package:coffee_shop/Features/Profile/Provider/scratch_provider.dart';
// import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:scratcher/scratcher.dart';
// import 'package:lottie/lottie.dart';

// class ScratchCardsScreen extends ConsumerStatefulWidget {
//   const ScratchCardsScreen({super.key});

//   @override
//   ConsumerState<ScratchCardsScreen> createState() => _ScratchCardsScreenState();
// }

// class _ScratchCardsScreenState extends ConsumerState<ScratchCardsScreen> {
//   final Map<int, bool> _isScratching = {};

//   @override
//   void initState() {
//     super.initState();
//     log('🟢 ScratchCardsScreen: initState called');
//     _loadScratchCards();
//   }

//   Future<void> _loadScratchCards() async {
//     log('🔄 Starting to load scratch cards...');
//     try {
//       await ref.read(scratchCardsProvider.notifier).loadScratchCards();
//       log('✅ Scratch cards loaded successfully');
//     } catch (e) {
//       log('❌ Failed to load scratch cards: $e');
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load scratch cards: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     log('🏗️ Building ScratchCardsScreen widget');
//     final scratchCards = ref.watch(scratchCardsProvider);
//     final scratchNotifier = ref.read(scratchCardsProvider.notifier);

//     log('📊 Current scratch cards count: ${scratchCards.length}');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Scratch Cards'),
//         backgroundColor: Colors.brown[700],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               log('🔄 Refresh button pressed');
//               _loadScratchCards();
//             },
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: scratchCards.isEmpty
//           ? _buildEmptyState()
//           : _buildScratchCardsGrid(scratchCards, scratchNotifier),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     log('➕ Add demo card button pressed');
//       //     _addDemoCard(scratchNotifier);
//       //   },
//       //   tooltip: 'Add Demo Card',
//       //   child: Icon(Icons.add),
//       // ),
//     );
//   }

//   Widget _buildEmptyState() {
//     log('🗂️ Building empty state');
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               constraints: const BoxConstraints(maxHeight: 200),
//               child: Lottie.asset(
//                 'Assets/Icons/Scratch Card.json',
//                 width: 200,
//                 height: 200,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'No scratch cards yet!',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Complete orders to earn scratch cards',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 log('🔄 Retry button pressed in empty state');
//                 _loadScratchCards();
//               },
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildScratchCardsGrid(
//     List<ScratchCardModel> scratchCards,
//     ScratchCardsNotifier scratchNotifier,
//   ) {
//     log('📱 Building scratch cards grid with ${scratchCards.length} items');
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.9, // Increased from 0.85 to give more height
//       ),
//       padding: const EdgeInsets.all(16),
//       itemCount: scratchCards.length,
//       itemBuilder: (context, index) {
//         final card = scratchCards[index];
//         final isScratching = _isScratching[card.id] ?? false;
//         log(
//           '🃏 Building card at index $index: ID=${card.id}, isScratched=${card.isScratched}, isClaimed=${card.isClaimed}',
//         );

//         return _buildScratchCardItem(card, isScratching, scratchNotifier);
//       },
//     );
//   }

//   Widget _buildScratchCardItem(
//     ScratchCardModel card,
//     bool isScratching,
//     ScratchCardsNotifier scratchNotifier,
//   ) {
//     log('🏗️ Building scratch card item for card ID: ${card.id}');
//     log('rewards $card.rewards');
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 // Card image/scratch area - takes most space
//                 Expanded(
//                   flex: 7,
//                   child: !card.isScratched
//                       ? _buildScratchArea(card, scratchNotifier)
//                       : _buildRevealedContent(card, scratchNotifier),
//                 ),

//                 // Bottom info section - fixed space
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Reward info
//                       Flexible(
//                         child: Text(
//                           card.isScratched ? card.reward : 'Hidden Reward',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: card.isScratched
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       // Date info
//                       Text(
//                         'Created: ${_formatDate(card.createdAt)}',
//                         style: const TextStyle(fontSize: 9, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Status badge
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: _getStatusColor(card),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 _getStatusText(card),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 9,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScratchArea(
//     ScratchCardModel card,
//     ScratchCardsNotifier scratchNotifier,
//   ) {
//     log('🔧 Building scratch area for card ID: ${card.id}');
//     return Scratcher(
//       key: Key('scratcher_${card.id}'),
//       brushSize: 35,
//       threshold: 60,
//       color: Colors.grey[800]!,
//       onScratchStart: () {
//         log('🖊️ Scratch started for card ID: ${card.id}');
//         setState(() {
//           _isScratching[card.id!] = true;
//         });
//       },
//       onScratchEnd: () async {
//         log('🏁 Scratch ended for card ID: ${card.id}');
//         setState(() {
//           _isScratching[card.id!] = false;
//         });

//         try {
//           log('💾 Marking card ${card.id} as scratched...');
//           await scratchNotifier.markAsScratched(card.id!);
//           log('✅ Card ${card.id} marked as scratched');
//           _showRewardDialog(card, scratchNotifier);
//         } catch (e) {
//           log('❌ Failed to scratch card ${card.id}: $e');
//           // ignore: use_build_context_synchronously
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('Failed to scratch card: $e')));
//         }
//       },
//       child: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Flexible(
//                 child: Lottie.asset(
//                   'assets/animations/scratch_me.json',
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 'Scratch Me!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRevealedContent(
//     ScratchCardModel card,
//     ScratchCardsNotifier scratchNotifier,
//   ) {
//     log('🎁 Building revealed content for card ID: ${card.id}');
//     return SizedBox(
//       width: double.infinity,
//       height: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Flexible(
//             flex: 3,
//             child: Image.asset(
//               card.imagePath,
//               width: 60,
//               height: 60,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 log('❌ Failed to load image: ${card.imagePath}');
//                 return Container(
//                   width: 60,
//                   height: 60,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.image_not_supported),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 8),
//           Flexible(
//             flex: 2,
//             child: Text(
//               card.reward,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: Colors.green,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Flexible(
//             flex: 1,
//             child: !card.isClaimed
//                 ? ElevatedButton(
//                     onPressed: () {
//                       log(
//                         '🎯 Claim reward button pressed for card ID: ${card.id}',
//                       );
//                       _claimReward(card, scratchNotifier);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       minimumSize: const Size(0, 28),
//                     ),
//                     child: const Text(
//                       'Claim Reward',
//                       style: TextStyle(fontSize: 10),
//                     ),
//                   )
//                 : const Text(
//                     'Claimed ✓',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(ScratchCardModel card) {
//     if (card.isClaimed) {
//       log('🟢 Card ${card.id} status: CLAIMED (green)');
//       return Colors.green;
//     }
//     if (card.isScratched) {
//       log('🟠 Card ${card.id} status: REVEALED (orange)');
//       return Colors.orange;
//     }
//     log('🔵 Card ${card.id} status: NEW (blue)');
//     return Colors.blue;
//   }

//   String _getStatusText(ScratchCardModel card) {
//     if (card.isClaimed) return 'CLAIMED';
//     if (card.isScratched) return 'REVEALED';
//     return 'NEW';
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   Future<void> _showRewardDialog(
//     ScratchCardModel card,
//     ScratchCardsNotifier scratchNotifier,
//   ) async {
//     log('🎉 Showing reward dialog for card ID: ${card.id}');
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Congratulations!'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               card.imagePath,
//               width: 100,
//               height: 100,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 width: 100,
//                 height: 100,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.image_not_supported),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'You won: ${card.reward}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               log('❌ Dialog closed without claiming');
//               Navigator.pop(context);
//             },
//             child: const Text('Close'),
//           ),
//           if (!card.isClaimed)
//             ElevatedButton(
//               onPressed: () {
//                 log('🎯 Claim now button pressed from dialog');
//                 Navigator.pop(context);
//                 _claimReward(card, scratchNotifier);
//               },
//               child: const Text('Claim Now'),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<void> _claimReward(
//     ScratchCardModel card,
//     ScratchCardsNotifier scratchNotifier,
//   ) async {
//     log('🎁 Attempting to claim reward for card ID: ${card.id}');
//     try {
//       await scratchNotifier.claimReward(card.id!);
//       log('✅ Reward claimed successfully for card ID: ${card.id}');
//       log('card rewards : $card.reward');
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text('Reward claimed: ${card.reward}'),),);
//     } catch (e) {
//       log('❌ Failed to claim reward for card ID: ${card.id}: $e');
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to claim reward: $e')));
//     }
//   }

//   // Future<void> _addDemoCard(ScratchCardsNotifier scratchNotifier) async {
//   //   log('➕ Adding demo card...');
//   //   try {
//   //     final newCard = ScratchCardModel(
//   //       isScratched: false,
//   //       createdAt: DateTime.now(),
//   //       reward: '20% Off',
//   //       isClaimed: false,
//   //       imagePath: 'assets/rewards/discount_20.png',
//   //     );

//   //     await scratchNotifier.addScratchCard(newCard);
//   //     log('✅ Demo card added successfully');
//   //     // ignore: use_build_context_synchronously
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Demo card added!'))
//   //     );
//   //   } catch (e) {
//   //     log('❌ Failed to add demo card: $e');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Failed to add card: $e'))
//   //     );
//   //   }
//   // }
// }
