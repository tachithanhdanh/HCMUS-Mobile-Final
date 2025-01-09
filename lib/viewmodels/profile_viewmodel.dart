// viewmodels/profile_viewmodel.dart
import 'package:recipe_app/models/user.dart';

class ProfileViewModel {
  // Lấy thông tin người dùng
  Future<User> getUserProfile(String userId) async {
    // Logic lấy hồ sơ người dùng
    return User(
      id: userId,
      username: 'JohnDoe',
      email: 'john@example.com',
      profilePictureUrl: '',
    ); // Placeholder
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(User user) async {
    // Logic cập nhật hồ sơ
  }
}
