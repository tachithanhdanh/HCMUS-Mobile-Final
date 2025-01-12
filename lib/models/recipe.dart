class Review {
  String id; // ID của đánh giá
  String userId; // ID người dùng viết đánh giá
  String content; // Nội dung đánh giá
  int rating; // Thang điểm 1-5
  DateTime createdAt; // Ngày tạo

  Review({
    required this.id,
    required this.userId,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      rating: data['rating'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
