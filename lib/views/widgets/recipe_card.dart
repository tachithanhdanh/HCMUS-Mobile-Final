import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../constants/colors.dart'; // Import AppColors

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  RecipeCard({
    required this.recipe,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppColors.pinkSubColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: recipe.imageUrl.isNotEmpty
                    ? Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      )
                    : Image.asset(
                        'assets/images/pochita.jpg',
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: GestureDetector(
                  onTap: onFavoriteToggle, // Toggle favorite state
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite // Filled heart
                          : Icons.favorite_border, // Outlined heart
                      color: AppColors.pinkSubColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkSubColor,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  recipe.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
