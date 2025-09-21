// // lib/Features/Profile/Provider/scratch_provider.dart
// import 'package:coffee_shop/DATABASE_HELPER/sracth_data.dart';
// import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final scratchCardDatabaseProvider = Provider<ScratchCardDatabase>((ref) {
//   return ScratchCardDatabase();
// });

// final scratchCardsProvider = StateNotifierProvider<ScratchCardsNotifier, List<ScratchCardModel>>((ref) {
//   return ScratchCardsNotifier(ref.read(scratchCardDatabaseProvider));
// });

// final availableDiscountsProvider = Provider<List<ScratchCardModel>>((ref) {
//   final scratchCards = ref.watch(scratchCardsProvider);
//   return scratchCards.where((card) => card.isClaimed && !card.isUsed).toList();
// });

// class ScratchCardsNotifier extends StateNotifier<List<ScratchCardModel>> {
//   final ScratchCardDatabase _database;

//   ScratchCardsNotifier(this._database) : super([]) {
//     loadScratchCards();
//   }

//   Future<void> loadScratchCards() async {
//     try {
//       final cards = await _database.getAllScratchCards();
//       state = cards;
//     } catch (e) {
//       state = [];
//       rethrow;
//     }
//   }

//   Future<void> addScratchCard(ScratchCardModel card) async {
//     try {
//       await _database.insertScratchCard(card);
//       await loadScratchCards();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> updateScratchCard(ScratchCardModel card) async {
//     try {
//       await _database.updateScratchCard(card);
//       await loadScratchCards();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> markAsScratched(int cardId) async {
//     try {
//       final cardIndex = state.indexWhere((card) => card.id == cardId);
//       if (cardIndex != -1) {
//         final card = state[cardIndex];
//         final updatedCard = card.copyWith(isScratched: true);
//         await _database.updateScratchCard(updatedCard);
//         await loadScratchCards();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> claimReward(int cardId) async {
//     try {
//       final cardIndex = state.indexWhere((card) => card.id == cardId);
//       if (cardIndex != -1) {
//         final card = state[cardIndex];
//         final updatedCard = card.copyWith(isClaimed: true);
//         await _database.updateScratchCard(updatedCard);
//         await loadScratchCards();
        
//         // Print reward details to console
//         _printRewardDetails(updatedCard);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> useDiscount(int cardId, String orderId) async {
//     try {
//       final cardIndex = state.indexWhere((card) => card.id == cardId);
//       if (cardIndex != -1) {
//         final card = state[cardIndex];
//         final updatedCard = card.copyWith(
//           isUsed: true,
//           usedInOrderId: orderId,
//           usedAt: DateTime.now(),
//         );
//         await _database.updateScratchCard(updatedCard);
//         await loadScratchCards();
        
//         // Print usage confirmation
//         _printDiscountUsage(updatedCard, orderId);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   void _printRewardDetails(ScratchCardModel card) {
//     print('''
// 🎯 SCRATCH CARD REWARD CLAIMED!
// ───────────────────────────────────────
// 📋 Card ID: ${card.id}
// 🎁 Reward: ${card.reward}
// 💰 Discount Value: ${_extractDiscountValue(card.reward)}
// 📅 Valid: Until used in an order
// 🔢 Discount Code: SCRATCH-${card.id}
// 💡 How to use:
//    - Proceed to checkout
//    - Apply discount code: SCRATCH-${card.id}
//    - The ${card.reward} will be automatically applied
//    - Card will be marked as used after successful payment
// ───────────────────────────────────────
// ''');
//   }

//   void _printDiscountUsage(ScratchCardModel card, String orderId) {
//     print('''
// ✅ SCRATCH CARD DISCOUNT APPLIED!
// ───────────────────────────────────────
// 📋 Card ID: ${card.id}
// 🎁 Reward: ${card.reward}
// 📦 Order ID: $orderId
// 💰 Discount Applied: ${_extractDiscountValue(card.reward)}
// ⏰ Applied at: ${DateTime.now()}
// ───────────────────────────────────────
// ''');
//   }

//   String _extractDiscountValue(String reward) {
//     if (reward.contains('%')) {
//       final regex = RegExp(r'(\d+)%');
//       final match = regex.firstMatch(reward);
//       return match != null ? '${match.group(1)}% discount' : reward;
//     } else if (reward.contains('\$')) {
//       final regex = RegExp(r'\$(\d+)');
//       final match = regex.firstMatch(reward);
//       return match != null ? '\$${match.group(1)} off' : reward;
//     } else if (reward.toLowerCase().contains('free')) {
//       return 'Free item';
//     }
//     return reward;
//   }

//   ScratchCardModel? getLatestCard() {
//     return state.isNotEmpty ? state.last : null;
//   }

//   ScratchCardModel? getCardById(int cardId) {
//     return state.firstWhere((card) => card.id == cardId);
//   }

//   List<ScratchCardModel> getAvailableDiscounts() {
//     return state.where((card) => card.isClaimed && !card.isUsed).toList();
//   }
// }