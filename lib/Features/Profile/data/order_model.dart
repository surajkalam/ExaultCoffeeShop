import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String? id;
  final String userId;
  final String imagePath;
  final String name;
  final double rating;
  final double quantity;
  final double total;
  final DateTime orderDate;
  final double unitPrice;
  final String? productId;

  OrderItem({
    this.id,
    required this.userId,
    required this.imagePath,
    required this.name,
    required this.rating,
    required this.quantity,
    required this.total,
    required this.unitPrice,
    this.productId,
    DateTime? orderDate,
  }) : orderDate = orderDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imagePath': imagePath,
      'name': name,
      'rating': rating,
      'quantity': quantity,
      'total': total,
      'unitPrice': unitPrice,
      'productId': productId,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderItem(
      id: documentId,
      userId: map['userId'] ?? '',
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      rating: (map['rating'] as num).toDouble(),
      quantity: (map['quantity'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      unitPrice: (map['unitPrice'] as num).toDouble(),
      productId: map['productId'],
      orderDate: (map['orderDate'] as Timestamp).toDate(),
    );
  }

  OrderItem copyWith({
    String? id,
    String? userId,
    String? imagePath,
    String? name,
    double? rating,
    double? quantity,
    double? total,
    double? unitPrice,
    String? productId,
    DateTime? orderDate,
  }) {
    return OrderItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      unitPrice: unitPrice ?? this.unitPrice,
      productId: productId ?? this.productId,
      orderDate: orderDate ?? this.orderDate,
    );
  }

  @override
  String toString() {
    return 'OrderItem(id: $id, name: $name, quantity: $quantity, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem &&
        other.id == id &&
        other.userId == userId &&
        other.imagePath == imagePath &&
        other.name == name &&
        other.rating == rating &&
        other.quantity == quantity &&
        other.total == total &&
        other.unitPrice == unitPrice &&
        other.productId == productId &&
        other.orderDate == orderDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        imagePath.hashCode ^
        name.hashCode ^
        rating.hashCode ^
        quantity.hashCode ^
        total.hashCode ^
        unitPrice.hashCode ^
        productId.hashCode ^
        orderDate.hashCode;
  }
}