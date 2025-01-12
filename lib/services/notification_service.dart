import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _notifications =>
      _firestore.collection('notifications');

  // Tạo thông báo mới
  Future<void> createNotification(Notification notification) async {
    try {
      await _notifications.add(notification.toMap());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  // Lấy danh sách thông báo của một user
  Future<List<Notification>> getUserNotifications(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _notifications
          .where('userId', isEqualTo: userId)
          .orderBy('sentAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Notification.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  // Đánh dấu thông báo là đã đọc
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notifications.doc(notificationId).update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Xóa thông báo
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notifications.doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Gửi thông báo gợi ý công thức
  Future<void> sendDailyRecipeNotification({
    required String userId,
    required String recipeId,
    required String message,
  }) async {
    try {
      Notification notification = Notification(
        id: '',
        userId: userId,
        recipeId: recipeId,
        message: message,
        sentAt: DateTime.now(),
        isRead: false,
      );

      await createNotification(notification);
    } catch (e) {
      throw Exception('Failed to send daily recipe notification: $e');
    }
  }
}
