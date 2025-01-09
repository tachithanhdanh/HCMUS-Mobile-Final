// viewmodels/home_viewmodel.dart
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user.dart';

class HomeViewModel {
  // Lấy danh sách công thức phổ biến
  Future<List<Recipe>> getTrendingRecipes() async {
    // Logic lấy công thức
    return []; // Placeholder
  }

  // Lấy danh sách Top Chefs
  Future<List<User>> getTopChefs() async {
    // Logic lấy Top Chefs
    return []; // Placeholder
  }
}
