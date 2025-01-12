import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/enums/category.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProfile currentUser = UserProfile(
      id: '3',
      name: 'Dianne',
      email: 'dianne@example.com',
      avatarUrl: '',
      favoriteRecipes: [],
    );

    final trendingRecipes = [
      Recipe(
        id: '1',
        title: 'Pasta Carbonara',
        description: 'A simple pasta dish',
        ingredients: ['Pasta', 'Eggs', 'Cheese', 'Bacon'],
        steps: ['Boil pasta', 'Cook bacon', 'Mix ingredients'],
        imageUrl: '',
        authorId: '1',
        reviews: [],
        createdAt: DateTime.now(),
        category: Category.MainCourse,
        cookTime: '30 mins', // Cập nhật cookTime
      )
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trending Recipe",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.redPinkMain,
              ),
            ),
            const SizedBox(height: 16),
            _buildTrendingRecipes(trendingRecipes),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingRecipes(List<Recipe> recipes) {
    return Column(
      children: recipes.map((recipe) => RecipeCard(recipe: recipe)).toList(),
    );
  }
}
