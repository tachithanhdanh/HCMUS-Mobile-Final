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

  // Hàm để cập nhật danh sách yêu thích
  void updateFavoriteRecipes(String recipeId) {
    if (currentUser == null) return;

    // Kiểm tra xem công thức đã được thêm vào yêu thích chưa
    final isFavorite = currentUser!.favoriteRecipes.contains(recipeId);
    if (isFavorite) {
      // Nếu đã thích thì bỏ thích
      currentUser!.favoriteRecipes.remove(recipeId);
    } else {
      // Nếu chưa thích thì thêm vào danh sách yêu thích
      currentUser!.favoriteRecipes.add(recipeId);
    }
    print("Changed favorite recipes");

    notifyListeners(); // Thông báo để cập nhật UI
  }

  // void updateFavoriteRecipes(List<String> favoriteRecipes) {
  //   if (_currentUser != null) {
  //     _currentUser = _currentUser!.copyWith(favoriteRecipes: favoriteRecipes);
  //     notifyListeners(); // Cập nhật danh sách yêu thích và thông báo thay đổi
  //   }
  // }
}
