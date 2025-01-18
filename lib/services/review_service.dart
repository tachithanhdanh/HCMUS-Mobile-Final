import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm review vào Recipe
  Future<void> addReview(String recipeId, Review review) async {
    try {
      final recipeRef = _firestore.collection('recipes').doc(recipeId);

      // Tạo một ID duy nhất cho review
      final String reviewId = _firestore.collection('dummy').doc().id;

      // Gắn ID vào review trước khi thêm
      final reviewWithId = review.toMap()..addAll({'id': reviewId});

      // Thêm review mới vào mảng reviews
      await recipeRef.update({
        'reviews': FieldValue.arrayUnion([reviewWithId]),
      });

      // Log để kiểm tra
      print('Review added successfully: $reviewWithId');
    } catch (error) {
      // Log lỗi nếu có
      print('Failed to add review: $error');
    }
  }

  // Lấy danh sách review theo Recipe
  Future<List<Review>> fetchReviewsByRecipe(String recipeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              Review.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reviews: ${e.toString()}');
    }
  }

  // Cập nhật review
  Future<void> updateReview(
      String recipeId, String reviewId, Review updatedReview) async {
    try {
      DocumentReference reviewDoc = _firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('reviews')
          .doc(reviewId);

      await reviewDoc.update(updatedReview.toMap());
    } catch (e) {
      throw Exception('Failed to update review: ${e.toString()}');
    }
  }

  // Xóa review
  Future<void> deleteReview(String recipeId, String reviewId) async {
    try {
      DocumentReference reviewDoc = _firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('reviews')
          .doc(reviewId);

      await reviewDoc.delete();
    } catch (e) {
      throw Exception('Failed to delete review: ${e.toString()}');
    }
  }
}
