// services/user_service.dart
import '../models/user.dart';

class UserService {
  // Đăng nhập người dùng
  Future<User> login(String email, String password) async {
    // Gọi API đăng nhập
    return User(
      id: 'user123',
      username: 'JohnDoe',
      email: email,
      profilePictureUrl: '',
    ); // Placeholder
  }

  // Đăng ký người dùng
  Future<User> signup(String username, String email, String password) async {
    // Gọi API đăng ký
    return User(
      id: 'user123',
      username: username,
      email: email,
      profilePictureUrl: '',
    ); // Placeholder
  }

  // Lấy thông tin người dùng
  Future<User> getUserProfile(String userId) async {
    // Gọi API lấy hồ sơ người dùng
    return User(
      id: userId,
      username: 'JohnDoe',
      email: 'john@example.com',
      profilePictureUrl: '',
      savedRecipes: ['recipe1', 'recipe2'],
      createdRecipes: ['recipe3'],
    ); // Placeholder
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(User user) async {
    // Gọi API cập nhật hồ sơ
  }

  // Đăng xuất người dùng
  Future<void> logout() async {
    // Gọi API đăng xuất
  }
}
