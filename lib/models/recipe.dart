// models/recipe.dart
class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final String imageUrl;
  final String authorId;
  final int likes;
  final String description;
  final String time;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.imageUrl,
    required this.authorId,
    required this.description,
    required this.time,
    this.likes = 0,
  });
}
