// models/user.dart
class User {
  final String id;
  final String username;
  final String email;
  final String profilePictureUrl;
  final List<String> savedRecipes;
  final List<String> createdRecipes;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    this.savedRecipes = const [],
    this.createdRecipes = const [],
  });
}
