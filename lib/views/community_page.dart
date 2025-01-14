import 'package:flutter/material.dart';
import 'package:recipe_app/views/widgets/community_recipe_card.dart';
import '../../models/recipe.dart';
import '../../models/user_profile.dart';
import '../../constants/colors.dart';

class CommunityPage extends StatelessWidget {
  final UserProfile currentUser;
  final List<Recipe> communityRecipes;
  final List<UserProfile> authors;
  final Function(Recipe) onToggleFavorite;

  CommunityPage({
    required this.currentUser,
    required this.communityRecipes,
    required this.authors,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(0.0), // Padding chung cho toàn bộ nội dung
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header (Instead of AppBar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                      onPressed: () {
                        Navigator.of(context).pop(); // Back action
                      },
                    ),
                    // Center Title
                    Text(
                      "Community",
                      style: TextStyle(
                        color: AppColors.redPinkMain,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Actions (Search, Notifications, Account)
                    Row(
                      children: [
                        _buildIconButton(
                          context,
                          Icons.search,
                          () {
                            // Search action
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          context,
                          Icons.notifications_none,
                          () {
                            // Notifications action
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          context,
                          Icons.account_circle,
                          () {
                            // Account action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Community Recipes Section
                Text(
                  "Top Recipes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redPinkMain,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: communityRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = communityRecipes[index];
                    final author = authors
                        .firstWhere((user) => user.id == recipe.authorId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CommunityRecipeCard(
                        recipe: recipe,
                        author: author,
                        isFavorite:
                            currentUser.favoriteRecipes.contains(recipe.id),
                        onFavoriteToggle: () => onToggleFavorite(recipe),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pink,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.pinkSubColor),
        iconSize: 20,
      ),
    );
  }
}
