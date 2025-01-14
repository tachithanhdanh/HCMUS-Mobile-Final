import 'package:recipe_app/models/user_profile.dart';

class ProfileViewModel {
  // Lấy thông tin người dùng
  Future<UserProfile> getUserProfile(String userId) async {
    // Logic lấy hồ sơ người dùng
    return UserProfile(
      id: userId,
      name: 'John Doe',
      email: 'johndoe@example.com',
      avatarUrl: 'https://via.placeholder.com/150',
      favoriteRecipes: ['recipe1', 'recipe2'],
    ); // Placeholder
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(UserProfile user) async {
    // Logic cập nhật hồ sơ
  }
}
