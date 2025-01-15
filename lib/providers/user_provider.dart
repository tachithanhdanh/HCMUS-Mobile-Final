import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;

  void setUser(UserProfile user) {
    _currentUser = user;
    notifyListeners(); // Cập nhật toàn bộ widget đang sử dụng dữ liệu này
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
