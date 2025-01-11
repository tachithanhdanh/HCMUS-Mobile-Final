import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock data for the current user
    final User currentUser = User(
      id: '3',
      username: 'Dianne',
      email: 'dianne@example.com',
      profilePictureUrl: '', // Có thể thêm ảnh profile nếu cần
      savedRecipes: [],
      createdRecipes: [],
    );

    // Mock data for Recipes
    final trendingRecipes = [
      Recipe(
        id: '1',
        title: 'Pasta Carbonara',
        ingredients: ['Pasta', 'Eggs', 'Cheese', 'Bacon'],
        instructions: ['Boil pasta', 'Cook bacon', 'Mix ingredients'],
        category: 'Italian',
        imageUrl: '',
        authorId: '1',
        likes: 100,
        description: 'A simple pasta dish',
        time: '30 mins',
      )
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header (Instead of AppBar)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dòng đầu tiên: Hi, user name và icon bên phải
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text: Hi, user name
                      Text(
                        "Hi! ${currentUser.username}",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Icon Actions
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.notifications_none,
                                color: Colors.redAccent),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.account_circle,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Dòng thứ hai: What are you cooking today
                  Text(
                    "What are you cooking today",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Trending Recipe Section
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

            const SizedBox(height: 32),

            // Your Recipes Section
            Text(
              "Your Recipes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildYourRecipes(trendingRecipes), // Sử dụng lại RecipeCard

            const SizedBox(height: 32),

            // Top Chef Section
            Text(
              "Top Chef",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
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

  Widget _buildYourRecipes(List<Recipe> recipes) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recipes.map((recipe) {
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RecipeCard(recipe: recipe),
          );
        }).toList(),
      ),
    );
  }
}
