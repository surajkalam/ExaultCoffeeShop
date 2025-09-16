// models/scratch_card_model.dart
class ScratchCardModel {
  final int? id;
  final bool isScratched;
  final DateTime createdAt;
  final String reward;
  final bool isClaimed;
  final String imagePath;

  ScratchCardModel({
    this.id,
    required this.isScratched,
    required this.createdAt,
    required this.reward,
    this.isClaimed = false,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isScratched': isScratched ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'reward': reward,
      'isClaimed': isClaimed ? 1 : 0,
        'imagePath': imagePath,
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
    );
  }

  ScratchCardModel copyWith({
    int? id,
    bool? isScratched,
    DateTime? createdAt,
    String? reward,
    bool? isClaimed,
    String? imagepath,
  }) {
    return ScratchCardModel(
      id: id ?? this.id,
      isScratched: isScratched ?? this.isScratched,
      createdAt: createdAt ?? this.createdAt,
      reward: reward ?? this.reward,
      isClaimed: isClaimed ?? this.isClaimed,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}