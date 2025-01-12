class User {
  String id;
  String name;
  String email;
  String avatarUrl;
  List<String> favoriteRecipes; // Danh sách recipeId yêu thích

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.favoriteRecipes,
  });

  factory User.fromMap(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      favoriteRecipes: List<String>.from(data['favoriteRecipes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'favoriteRecipes': favoriteRecipes,
    };
  }
}
