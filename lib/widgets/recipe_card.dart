import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../constants/colors.dart'; // Import AppColors
import '../widgets/favorite_button.dart'; // Import FavoriteButton

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onRecipeUpdated; // Callback tùy chọn

  RecipeCard({
    required this.recipe,
    this.onRecipeUpdated,
  });

  // Hàm tính trung bình số sao phần nguyên từ danh sách reviews
  double getAverageRating() {
    if (recipe.reviews.isEmpty) return 0;
    int totalRatings = recipe.reviews
        .map((review) => review.rating) // Lấy danh sách ratings
        .reduce((a, b) => a + b); // Tính tổng
    double average = totalRatings.toDouble() / recipe.reviews.length;
    return double.parse(average.toStringAsFixed(1)); // Lấy phần nguyên
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Nếu chiều rộng nhỏ hơn 200, chuyển sang hiển thị 3 dòng
        final isCompact = constraints.maxWidth < 200;

        return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/recipe_details',
                arguments: recipe.id, // Truyền ID recipe
              );
            },
            borderRadius: BorderRadius.circular(
                12.0), // Để hiệu ứng nhấn theo hình dạng Card
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: AppColors.pinkSubColor, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Hình ảnh công thức
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.0)),
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
                      // Nút FavoriteButton
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: FavoriteButton(
                          recipeId: recipe.id, // Truyền ID của công thức
                          onRecipeUpdated: onRecipeUpdated, // Truyền callback
                        ),
                      ),
                    ],
                  ),
                  // Nội dung bên dưới
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: isCompact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.brownPod,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppColors.pinkSubColor,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    recipe.cookTime,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.pinkSubColor,
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
                                    color: AppColors.pinkSubColor,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '${getAverageRating()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.pinkSubColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bên trái: Title và Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.brownPod,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      recipe.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.brownPod,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Bên phải: Time và Ratings
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: AppColors.pinkSubColor,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        recipe.cookTime,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.pinkSubColor,
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
                                        color: AppColors.pinkSubColor,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        '${getAverageRating()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.pinkSubColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
