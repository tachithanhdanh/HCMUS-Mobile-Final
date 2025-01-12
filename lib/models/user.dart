import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final List<String> favoriteRecipes;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    List<String>? favoriteRecipes,
  }) : favoriteRecipes = favoriteRecipes ?? [];

  // Tạo UserProfile từ Firebase Auth User
  factory UserProfile.fromFirebaseUser(auth.User firebaseUser) {
    return UserProfile(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email!,
      avatarUrl: firebaseUser.photoURL ?? '',
      favoriteRecipes: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'favoriteRecipes': favoriteRecipes,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'] ?? '',
      favoriteRecipes: List<String>.from(map['favoriteRecipes'] ?? []),
    );
  }

  // Tạo bản copy với các thay đổi
  UserProfile copyWith({
    String? name,
    String? avatarUrl,
    List<String>? favoriteRecipes,
  }) {
    return UserProfile(
      id: this.id,
      name: name ?? this.name,
      email: this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
    );
  }
}
