// utils/validators.dart
class Validators {
  // Kiểm tra định dạng email
  static bool isValidEmail(String email) {
    // Logic kiểm tra email
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Kiểm tra độ dài mật khẩu
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Kiểm tra tên người dùng
  static bool isValidUsername(String username) {
    return username.isNotEmpty;
  }
}
