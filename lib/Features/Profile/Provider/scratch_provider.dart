// providers/scratch_card_provider.dart
import 'package:coffee_shop/DATABASE_HELPER/sracth_data.dart';
import 'package:coffee_shop/Features/Profile/data/scratch_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final scratchCardDatabaseProvider = Provider<ScratchCardDatabase>((ref) {
  return ScratchCardDatabase();
});

final scratchCardsProvider = StateNotifierProvider<ScratchCardsNotifier, List<ScratchCardModel>>((ref) {
  return ScratchCardsNotifier(ref.read(scratchCardDatabaseProvider));
});

class ScratchCardsNotifier extends StateNotifier<List<ScratchCardModel>> {
  final ScratchCardDatabase _database;

  ScratchCardsNotifier(this._database) : super([]) {
    loadScratchCards();
  }

  Future<void> loadScratchCards() async {
    final cards = await _database.getAllScratchCards();
    state = cards;
  }

  Future<void> addScratchCard(ScratchCardModel card) async {
    await _database.insertScratchCard(card);
    await loadScratchCards();
  }

  Future<void> updateScratchCard(ScratchCardModel card) async {
    await _database.updateScratchCard(card);
    await loadScratchCards();
  }

  ScratchCardModel? getLatestCard() {
    return state.isNotEmpty ? state.last : null;
  }
}