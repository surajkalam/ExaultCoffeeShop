// models/item_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id; // For document ID
  final String name;
  final String type;
  final double rating;
  final String image;
  final String description;
  final double price;
  final String category;
  final Timestamp timestamp;
  final bool isAvailable; 


  Item({
    this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.image,
    required this.description,
    required this.price,
    required this.category,
    required this.timestamp,
    this.isAvailable = true,
    
  });

  // Convert Item to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'rating': rating,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'timestamp': timestamp,
        'isAvailable': isAvailable,
    };
  }

  // Create Item from Firestore document
  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      isAvailable: map['isAvailable'] ?? true, 
    );
  }

  // For creating a copy with updated values
  Item copyWith({
    String? id,
    String? name,
    String? type,
    double? rating,
    String? image,
    String? description,
    double? price,
    String? category,
    Timestamp? timestamp,
    bool? isAvailable,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
       isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  String toString() {
    return 'Item(id: $id, name: $name, type: $type, rating: $rating, price: $price, category: $category)';
  }
}