import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm review vào Recipe
  Future<void> addReview(String recipeId, Review review) async {
    try {
      DocumentReference recipeDoc = _firestore.collection('recipes').doc(recipeId);

      // Thêm review vào collection reviews của công thức
      await recipeDoc.collection('reviews').add(review.toMap());
    } catch (e) {
      throw Exception('Failed to add review: ${e.toString()}');
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
          .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reviews: ${e.toString()}');
    }
  }

  // Cập nhật review
  Future<void> updateReview(String recipeId, String reviewId, Review updatedReview) async {
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
