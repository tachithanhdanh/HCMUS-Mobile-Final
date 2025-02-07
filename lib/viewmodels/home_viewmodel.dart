import 'package:recipe_app/enums/category.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';

class HomeViewModel {
  // Lấy danh sách công thức phổ biến
  Future<List<Recipe>> getTrendingRecipes() async {
    // Logic lấy công thức
    return [
      Recipe(
        id: '1',
        title: 'Pasta Carbonara',
        description: 'Classic Italian pasta dish.',
        ingredients: ['Pasta', 'Eggs', 'Cheese', 'Bacon'],
        steps: ['Step 1', 'Step 2'],
        imageUrl: '',
        authorId: 'author1',
        reviews: [],
        createdAt: DateTime.now(),
        category: Category.MainCourse,
        cookTime: '30 mins', // Cập nhật cookTime
        difficulty: Difficulty.Medium,
      ),
    ]; // Placeholder
  }

  // Lấy danh sách Top Chefs
  Future<List<UserProfile>> getTopChefs() async {
    // Logic lấy Top Chefs
    return [
      UserProfile(
        id: 'chef1',
        name: 'Chef John',
        email: 'chefjohn@example.com',
        avatarUrl: '',
        favoriteRecipes: ['recipe1'],
      ),
    ]; // Placeholder
  }
}
