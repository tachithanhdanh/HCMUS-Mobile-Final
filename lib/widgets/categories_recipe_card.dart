import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/favorite_button.dart';
import '../models/recipe.dart';
import '../models/user_profile.dart';
import '../constants/colors.dart'; // Import AppColors

class CategoriesRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final UserProfile author;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CategoriesRecipeCard({super.key,
    required this.recipe,
    required this.author,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      // Navigate to the Recipe Details Page
      Navigator.pushNamed(
        context,
        '/recipe_details',
        arguments: recipe.id, // Pass the recipe ID as an argument
      );
    },
    child: Card(
      color: AppColors.redPinkMain, // Đặt màu nền tại đây
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image with Favorite Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180.0,
                  )
                      : Image.asset(
                    'assets/images/pochita.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180.0,
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    // onTap: onFavoriteToggle, // Toggle favorite state
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6.0),
                      child: FavoriteButton(
                          recipeId: recipe.id,
                          onRecipeUpdated: onFavoriteToggle
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Hàng 1: Recipe Title
            Text(
              recipe.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteBeige,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            // Hàng 2: Cook Time and Rating
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.whiteBeige,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      recipe.cookTime,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.whiteBeige,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.whiteBeige,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${getAverageRating()}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.whiteBeige,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Hàng 3: Description
            Text(
              recipe.description,
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.whiteBeige,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ));
  }

  double getAverageRating() {
    if (recipe.reviews.isEmpty) return 0.0;
    double average =
        recipe.reviews.map((e) => e.rating).reduce((a, b) => a + b) /
            recipe.reviews.length;
    return double.parse(average.toStringAsFixed(1));
  }
}
