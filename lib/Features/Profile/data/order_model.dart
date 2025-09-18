// order_model.dart
class PaymentData {
  final int? id;
  final String productName;
  final int quantity;
  final double price;
  final double totalPrice;
  final String status;
  final DateTime completedAt;

  PaymentData({
    this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.status,
    required this.completedAt,
  });

  // Convert PaymentData to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'status': status,
      'completedAt': completedAt.toIso8601String(), // Convert DateTime to String
    };
  }

  // Create PaymentData from Map
  factory PaymentData.fromMap(Map<String, dynamic> map) {
    return PaymentData(
      id: map['id'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      totalPrice: map['totalPrice'].toDouble(),
      status: map['status'],
      completedAt: DateTime.parse(map['completedAt']), // Convert String to DateTime
    );
  }
}