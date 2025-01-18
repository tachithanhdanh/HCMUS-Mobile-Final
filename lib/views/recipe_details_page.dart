import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/mock_data.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/providers/user_provider.dart';
import 'package:recipe_app/services/recipe_service.dart';

import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/widgets/favorite_button.dart';
import 'package:recipe_app/widgets/recipe_detail_card.dart';
import 'package:recipe_app/widgets/recipe_user_profile_row.dart';

class RecipeDetailsPage extends StatefulWidget {
  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  final RecipeService _recipeService = RecipeService();
  late Future<Recipe> _recipe;
  late String _recipeId;
  UserProfile? currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy recipeId từ arguments khi điều hướng đến trang này
    _recipeId = ModalRoute.of(context)!.settings.arguments as String;
    _recipe = _recipeService.fetchRecipeDetails(_recipeId);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUser = userProvider.currentUser;
  }

  void _saveRecipe(String userId, String recipeId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recipe saved successfully!')),
    );
  }

  void _shareRecipe(String recipeId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recipe shared successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Recipe>(
        future: _recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No recipe details found.'));
          } else {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header (Instead of AppBar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: AppColors.redPinkMain),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        "${recipe.title}",
                        style: TextStyle(
                          color: AppColors.redPinkMain,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Biểu tượng trái tim và chia sẻ
                      Row(
                        children: [
                          FavoriteButton(
                            recipeId: recipe.id,
                            onRecipeUpdated: () {
                              // Đồng bộ lại danh sách yêu thích nếu cần
                              setState(() {});
                            },
                          ),

                          // Biểu tượng chia sẻ
                          IconButton(
                            icon:
                                Icon(Icons.share, color: AppColors.redPinkMain),
                            onPressed: () {
                              _shareRecipe(_recipeId); // Gọi hàm chia sẻ
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RecipeDetailCard(recipe: recipe),
                  const SizedBox(height: 16),
                  RecipeUserProfileRow(
                    authorId: recipe.authorId, // ID của tác giả
                    isAuthorCurrentUser:
                        currentUser!.id == recipe.authorId, // So sánh ID
                    recipeId: recipe.id, // ID của recipe
                  ),
                  const SizedBox(height: 16),
                  // Phần Details
                  Row(
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.redPinkMain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.cookTime,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phần Ingredients
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redPinkMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.ingredients.map((ingredient) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.redPinkMain,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Phần Steps
                  Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redPinkMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.redPinkMain,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
