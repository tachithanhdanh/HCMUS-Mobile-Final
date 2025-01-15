import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/review.dart';
import '../enums/category.dart';

enum Difficulty {
  Easy,
  Medium,
  Hard,
  VeryHard,
}

class Recipe {
  String id;
  String title;
  String description;
  List<String> ingredients;
  List<String> steps;
  String imageUrl;
  String authorId;
  List<Review> reviews;
  DateTime createdAt;
  Category category;
  String cookTime;
  Difficulty difficulty;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.authorId,
    required this.reviews,
    required this.createdAt,
    required this.category,
    required this.cookTime,
    required this.difficulty,
  });

  factory Recipe.fromMap(Map<String, dynamic> data, String id) {
    List<Review> parseReviews(dynamic reviewsData) {
      if (reviewsData is List) {
        print(reviewsData[0]['id']);
        return reviewsData
            .map((review) =>
                Review.fromMap(review as Map<String, dynamic>, review['id']))
            .toList();
      }
      return [];
    }

    return Recipe(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      authorId: data['authorId'] ?? '',
      reviews: parseReviews(data['reviews']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: Category.values.firstWhere(
          (e) => e.toString() == 'Category.${data['category']}',
          orElse: () => Category.Other),
      cookTime: data['cookTime'] ?? '',
      difficulty: Difficulty.values.firstWhere(
          (e) => e.toString() == 'Difficulty.${data['difficulty']}',
          orElse: () => Difficulty.Medium),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'category': category.name,
      'cookTime': cookTime,
      'difficulty': difficulty.name,
    };
  }
}
