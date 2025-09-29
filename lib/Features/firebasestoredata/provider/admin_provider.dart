// providers/admin_providers.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Features/Home/models/items_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AdminTab {
  items,
  offers,
  vouchers,
  analytics
}

// Admin Tab Provider
final adminTabProvider = StateProvider<AdminTab>((ref) => AdminTab.items);
final adminStateProvider = StateProvider<int>((ref) => 0);

// Items Provider for CRUD operations - FIXED VERSION
final itemsProvider = StateNotifierProvider<ItemsNotifier, ItemsState>((ref) {
  return ItemsNotifier();
});

class ItemsState {
  final List<Item> items;
  final bool isLoading;
  final String? error;

  ItemsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  ItemsState copyWith({
    List<Item>? items,
    bool? isLoading,
    String? error,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ItemsNotifier extends StateNotifier<ItemsState> {
  ItemsNotifier() : super(ItemsState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _mainDocId = '1757264051191711';

  // Define all possible categories to avoid using listCollections()
  final List<String> _allCategories = [
    'coffee',
    'tea', 
    'cooler',
    'snacks',
    'frozen',
    'crispy delicious',
    'breadcraft',
    'house specials',
    'continental',
    'dessertduo'
  ];

  // Fetch all items from all categories - FIXED without listCollections()
  Future<void> fetchAllItems() async {
    print('🔄 Starting to fetch all items...');
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final List<Item> allItems = [];
      
      // Fetch from each known category sequentially
      for (final category in _allCategories) {
        try {
          final querySnapshot = await _firestore
              .collection('items')
              .doc(_mainDocId)
              .collection(category)
              .get();

          print('📂 Found ${querySnapshot.docs.length} items in $category');
          
          for (var doc in querySnapshot.docs) {
            try {
              final itemData = doc.data();
              final item = Item.fromMap(itemData, doc.id);
              allItems.add(item);
              print('✅ Loaded item: ${item.name} from $category');
            } catch (e) {
              print('❌ Error parsing item ${doc.id} in $category: $e');
            }
          }
        } catch (e) {
          // If a category doesn't exist, just skip it
          print('⚠️ Category $category might not exist or error: $e');
          continue;
        }
      }

      state = state.copyWith(items: allItems, isLoading: false);
      print('🎉 Successfully fetched ${allItems.length} items in total');
    } catch (e) {
      print('💥 Error fetching all items: $e');
      state = state.copyWith(
        error: 'Failed to fetch items: $e', 
        isLoading: false
      );
    }
  }

  // Fetch items by specific category
  Future<void> fetchItemsByCategory(String category) async {
    print('🔄 Fetching items from category: $category');
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final querySnapshot = await _firestore
          .collection('items')
          .doc(_mainDocId)
          .collection(category.toLowerCase())
          .get();

      final items = querySnapshot.docs
          .map((doc) => Item.fromMap(doc.data(), doc.id))
          .toList();

      state = state.copyWith(items: items, isLoading: false);
      print('✅ Successfully fetched ${items.length} items from $category category');
    } catch (e) {
      print('💥 Error fetching items from $category: $e');
      state = state.copyWith(
        error: 'Failed to fetch items: $e', 
        isLoading: false
      );
    }
  }

  // Add new item
  Future<void> addItem(Item item, String category) async {
    print('➕ Adding new item: ${item.name} to category: $category');
    try {
      final itemData = item.toMap();
      
      await _firestore
          .collection('items')
          .doc(_mainDocId)
          .collection(category.toLowerCase())
          .add(itemData);
      
      print('✅ Item added successfully to $category category');
      
      // Refresh the list
      await fetchAllItems();
    } catch (e) {
      print('💥 Error adding item: $e');
      throw Exception('Failed to add item: $e');
    }
  }

  // Update item
  Future<void> updateItem(Item item, String category) async {
    print('✏️ Updating item: ${item.name} (ID: ${item.id})');
    try {
      if (item.id == null) {
        throw Exception('Item ID is null');
      }
      
      await _firestore
          .collection('items')
          .doc(_mainDocId)
          .collection(category.toLowerCase())
          .doc(item.id!)
          .update(item.toMap());
      
      print('✅ Item updated successfully');
      
      // Refresh the list
      await fetchAllItems();
    } catch (e) {
      print('💥 Error updating item: $e');
      throw Exception('Failed to update item: $e');
    }
  }

  // Delete item
  Future<void> deleteItem(String itemId, String category) async {
    print('🗑️ Deleting item ID: $itemId from category: $category');
    try {
      await _firestore
          .collection('items')
          .doc(_mainDocId)
          .collection(category.toLowerCase())
          .doc(itemId)
          .delete();
      
      print('✅ Item deleted successfully');
      
      // Refresh the list
      await fetchAllItems();
    } catch (e) {
      print('💥 Error deleting item: $e');
      throw Exception('Failed to delete item: $e');
    }
  }

  // Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Statistics Provider - FIXED without listCollections()
final statsProvider = FutureProvider<Map<String, int>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  print('📊 Fetching statistics...');
  
  try {
    int totalItems = 0;
    
    // Define categories to check
    final categories = [
      'coffee', 'tea', 'cooler', 'snacks', 'frozen', 
      'crispy delicious', 'breadcraft', 'house specials', 
      'continental', 'dessertduo'
    ];
    
    // Count items in each category
    for (final category in categories) {
      try {
        final query = firestore
            .collection('items')
            .doc('1757264051191711')
            .collection(category);
        
        final snapshot = await query.get();
        totalItems += snapshot.docs.length;
        print('📈 Category $category: ${snapshot.docs.length} items');
      } catch (e) {
        print('⚠️ Could not count category $category: $e');
      }
    }
    
    // Get counts from other collections (you can add these later)
    // For now, return 0 for other stats
    final stats = {
      'totalItems': totalItems,
      'activeOffers': 0,
      'vouchers': 0,
      'newArrivals': 0,
      'seasonalItems': 0,
    };
    
    print('📊 Statistics fetched: $stats');
    return stats;
  } catch (e) {
    print('💥 Error fetching stats: $e');
    return {
      'totalItems': 0,
      'activeOffers': 0,
      'vouchers': 0,
      'newArrivals': 0,
      'seasonalItems': 0,
    };
  }
});

// Image Upload Provider
final imageUploadProvider = StateNotifierProvider<ImageUploadNotifier, ImageUploadState>((ref) {
  return ImageUploadNotifier();
});

class ImageUploadState {
  final bool isUploading;
  final String? imageUrl;
  final String? error;

  ImageUploadState({
    this.isUploading = false,
    this.imageUrl,
    this.error,
  });

  ImageUploadState copyWith({
    bool? isUploading,
    String? imageUrl,
    String? error,
  }) {
    return ImageUploadState(
      isUploading: isUploading ?? this.isUploading,
      imageUrl: imageUrl ?? this.imageUrl,
      error: error ?? this.error,
    );
  }
}

class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  ImageUploadNotifier() : super(ImageUploadState());

  Future<void> uploadImage(File image) async {
    print('🖼️ Starting image upload...');
    state = state.copyWith(isUploading: true, error: null);
    
    try {
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = 'items/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageRef = storageRef.child(fileName);

      print('📤 Uploading image to: $fileName');
      final uploadTask = imageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      state = state.copyWith(
        isUploading: false,
        imageUrl: downloadUrl,
      );
      print('✅ Image uploaded successfully: $downloadUrl');
    } catch (e) {
      print('💥 Error uploading image: $e');
      state = state.copyWith(
        isUploading: false,
        error: 'Failed to upload image: $e',
      );
    }
  }

  void clearImage() {
    print('🗑️ Clearing uploaded image');
    state = ImageUploadState();
  }
}

// Debug Provider to monitor state changes
final debugProvider = Provider<void>((ref) {
  final itemsState = ref.watch(itemsProvider);
  print('🐛 DEBUG - Items State:');
  print('   📦 Items Count: ${itemsState.items.length}');
  print('   ⏳ Loading: ${itemsState.isLoading}');
  print('   ❌ Error: ${itemsState.error}');
  
  if (itemsState.items.isNotEmpty) {
    print('   📋 Sample Items:');
    for (var item in itemsState.items.take(3)) {
      print('      - ${item.name} (${item.category}) - \$${item.price}');
    }
    if (itemsState.items.length > 3) {
      print('      ... and ${itemsState.items.length - 3} more');
    }
  }
});

// Category list provider for UI
final categoriesProvider = Provider<List<String>>((ref) {
  return [
    'All',
    'Coffee',
    'Tea',
    'Cooler',
    'Snacks',
    'Frozen',
    'Crispy Delicious',
    'Breadcraft',
    'House Specials',
    'Continental',
    'DessertDuo'
  ];
});