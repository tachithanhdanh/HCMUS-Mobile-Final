import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/review.dart';

import '../enums/category.dart';

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
  });

  factory Recipe.fromMap(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      authorId: data['authorId'] ?? '',
      reviews: List<Review>.from(data['reviews'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      category: Category.values.firstWhere(
          (e) => e.toString() == 'Category.${data['category']}',
          orElse: () => Category.Other),
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
      'createdAt': createdAt,
      'reviews': reviews,
      'category': category.name,
    };
  }
}
