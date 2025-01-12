import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String id;
  String userId; // ID của người dùng nhận thông báo
  String recipeId; // ID của công thức được gợi ý
  String message;
  DateTime sentAt;
  bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.message,
    required this.sentAt,
    required this.isRead,
  });

  factory Notification.fromMap(Map<String, dynamic> data, String id) {
    return Notification(
      id: id,
      userId: data['userId'] ?? '',
      recipeId: data['recipeId'] ?? '',
      message: data['message'] ?? '',
      sentAt: (data['sentAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'recipeId': recipeId,
      'message': message,
      'sentAt': sentAt,
      'isRead': isRead,
    };
  }
}
