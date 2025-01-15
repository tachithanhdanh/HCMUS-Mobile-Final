import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../models/user_profile.dart';
import '../../constants/colors.dart'; // Import AppColors

class CommunityRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final UserProfile author;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  CommunityRecipeCard({
    required this.recipe,
    required this.author,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.redPinkMain, // Đặt màu nền tại đây
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Information
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: author.avatarUrl.isNotEmpty
                      ? NetworkImage(author.avatarUrl)
                      : AssetImage('assets/images/gojo_satoru.png'),
                  radius: 20.0,
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${author.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: AppColors.whiteBeige,
                      ),
                    ),
                    Text(
                      '${_timeAgo(recipe.createdAt)}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.whiteBeige,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
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
            SizedBox(height: 8.0),
            // Recipe Title, Ratings, Description, Cook Time, and Comments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteBeige,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        recipe.description,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.whiteBeige,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Time and Ratings
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                            fontSize: 14,
                            color: AppColors.whiteBeige,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
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
                            fontSize: 14,
                            color: AppColors.whiteBeige,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} years ago";
    } else if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "just now";
    }
  }

  double getAverageRating() {
    if (recipe.reviews.isEmpty) return 0.0;
    return recipe.reviews.map((e) => e.rating).reduce((a, b) => a + b) /
        recipe.reviews.length;
  }
}
