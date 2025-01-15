import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';

class TrendingRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final String authorName;

  TrendingRecipeCard({
    required this.recipe,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.authorName,
  });

  // Hàm tính trung bình số sao phần nguyên từ danh sách reviews
  double getAverageRating() {
    if (recipe.reviews.isEmpty) return 0;
    int totalRatings = recipe.reviews
        .map((review) => review.rating) // Lấy danh sách ratings
        .reduce((a, b) => a + b); // Tính tổng
    double average = totalRatings.toDouble() / recipe.reviews.length;
    return double.parse(average.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppColors.redPinkMain, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh công thức
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          height: 120,
                          width: 120,
                        )
                      : Image.asset(
                          'assets/images/pochita.jpg', // Hình mặc định
                          fit: BoxFit.cover,
                          height: 135,
                          width: 135,
                        ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4.0), // Giảm padding
                      child: Icon(
                        isFavorite
                            ? Icons.favorite // Filled heart
                            : Icons.favorite_border, // Outlined heart
                        color: AppColors.redPinkMain,
                        size: 20.0, // Kích thước biểu tượng nhỏ hơn
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8.0),
            // Nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorBrown,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Mô tả
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColorBrown,
                    ),
                    maxLines: 4, // Hiển thị tối đa 4 dòng
                    overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                  ),
                  const SizedBox(height: 8.0),
                  // Tên tác giả
                  Text(
                    "By $authorName",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.redPinkMain,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Thông tin nấu ăn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Thời gian nấu
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.redPinkMain,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            recipe.cookTime,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColorBrown,
                            ),
                          ),
                        ],
                      ),
                      // Độ khó
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 16,
                            color: AppColors.redPinkMain,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            recipe.difficulty
                                .toString()
                                .split('.')
                                .last
                                .replaceAllMapped(
                                    RegExp(r'(?<=[a-z])(?=[A-Z])'),
                                    (match) => ' '),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColorBrown,
                            ),
                          ),
                        ],
                      ),
                      // Số sao trung bình
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.redPinkMain,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            getAverageRating().toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColorBrown,
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
      ),
    );
  }
}
