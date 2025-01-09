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

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.imageUrl,
    required this.authorId,
    this.likes = 0,
  });
}
