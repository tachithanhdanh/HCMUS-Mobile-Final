class Review {
  String id;
  String userId;
  String content;
  int rating; // Thang điểm từ 1 đến 5
  DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> data, String id) {
    return Review(
      id: id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      rating: data['rating'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
