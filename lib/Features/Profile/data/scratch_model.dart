// // models/scratch_card_model.dart
// class ScratchCardModel {
//   final int? id;
//   final bool isScratched;
//   final DateTime createdAt;
//   final String reward;
//   final bool isClaimed;
//   final String imagePath;

//   ScratchCardModel({
//     this.id,
//     required this.isScratched,
//     required this.createdAt,
//     required this.reward,
//     this.isClaimed = false,
//     required this.imagePath,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'isScratched': isScratched ? 1 : 0,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'reward': reward,
//       'isClaimed': isClaimed ? 1 : 0,
//         'imagePath': imagePath,
//     };
//   }

//   factory ScratchCardModel.fromMap(Map<String, dynamic> map) {
//     return ScratchCardModel(
//       id: map['id'],
//       isScratched: map['isScratched'] == 1,
//       createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
//       reward: map['reward'],
//       isClaimed: map['isClaimed'] == 1,
//       imagePath: map['imagePath'],
//     );
//   }

//   ScratchCardModel copyWith({
//     int? id,
//     bool? isScratched,
//     DateTime? createdAt,
//     String? reward,
//     bool? isClaimed,
//     String? imagepath,
//   }) {
//     return ScratchCardModel(
//       id: id ?? this.id,
//       isScratched: isScratched ?? this.isScratched,
//       createdAt: createdAt ?? this.createdAt,
//       reward: reward ?? this.reward,
//       isClaimed: isClaimed ?? this.isClaimed,
//       imagePath: imagePath ?? this.imagePath,
//     );
//   }
// }
// lib/Features/Profile/data/scratch_model.dart
class ScratchCardModel {
  final int? id;
  final bool isScratched;
  final DateTime createdAt;
  final String reward;
  final bool isClaimed;
  final String imagePath;
  final bool isUsed; // Track if the discount has been used
  final String? usedInOrderId; // Track which order used this discount
  final DateTime? usedAt; // When the discount was used

  ScratchCardModel({
    this.id,
    required this.isScratched,
    required this.createdAt,
    required this.reward,
    required this.isClaimed,
    required this.imagePath,
    this.isUsed = false,
    this.usedInOrderId,
    this.usedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isScratched': isScratched ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'reward': reward,
      'isClaimed': isClaimed ? 1 : 0,
      'imagePath': imagePath,
      'isUsed': isUsed ? 1 : 0,
      'usedInOrderId': usedInOrderId,
      'usedAt': usedAt?.millisecondsSinceEpoch,
    };
  }

  factory ScratchCardModel.fromMap(Map<String, dynamic> map) {
    return ScratchCardModel(
      id: map['id'],
      isScratched: map['isScratched'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      reward: map['reward'],
      isClaimed: map['isClaimed'] == 1,
      imagePath: map['imagePath'],
      isUsed: map['isUsed'] == 1,
      usedInOrderId: map['usedInOrderId'],
      usedAt: map['usedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['usedAt'])
          : null,
    );
  }

  // Add copyWith method for easy updates
  ScratchCardModel copyWith({
    int? id,
    bool? isScratched,
    DateTime? createdAt,
    String? reward,
    bool? isClaimed,
    String? imagePath,
    bool? isUsed,
    String? usedInOrderId,
    DateTime? usedAt,
  }) {
    return ScratchCardModel(
      id: id ?? this.id,
      isScratched: isScratched ?? this.isScratched,
      createdAt: createdAt ?? this.createdAt,
      reward: reward ?? this.reward,
      isClaimed: isClaimed ?? this.isClaimed,
      imagePath: imagePath ?? this.imagePath,
      isUsed: isUsed ?? this.isUsed,
      usedInOrderId: usedInOrderId ?? this.usedInOrderId,
      usedAt: usedAt ?? this.usedAt,
    );
  }
}