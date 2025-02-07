import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String content;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.content,
    required this.rating,
    required this.createdAt,
  }) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
    if (userId.isEmpty) {
      throw ArgumentError('UserId cannot be empty');
    }
  }

  factory Review.fromMap(Map<String, dynamic> data, String id) {
    DateTime getDateTime(dynamic date) {
      if (date is Timestamp) {
        return date.toDate();
      } else if (date is DateTime) {
        return date;
      }
      return DateTime.now();
    }

    return Review(
      id: id,
      userId: data['userId'] as String,
      content: data['content'] ?? '',
      rating: data['rating'] ?? 0,
      createdAt: getDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Review copyWith({
    String? userId,
    String? content,
    int? rating,
    DateTime? createdAt,
  }) {
    return Review(
      id: id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          content == other.content &&
          rating == other.rating &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      content.hashCode ^
      rating.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'Review(id: $id, userId: $userId, rating: $rating, createdAt: $createdAt)';
  }
}
