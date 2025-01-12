import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../constants/colors.dart'; // Import AppColors

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  // Hàm tính trung bình số sao phần nguyên từ danh sách reviews
  double getAverageRating() {
    if (recipe.reviews.isEmpty) return 0;
    int totalRatings = recipe.reviews
        .map((review) => review.rating) // Lấy danh sách ratings
        .reduce((a, b) => a + b); // Tính tổng
    double average = totalRatings.toDouble() /
        recipe.reviews.length; // Chuyển đổi totalRatings thành double
    return double.parse(average.toStringAsFixed(1)); // Lấy phần nguyên
  }

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
          // Hình ảnh với biểu tượng trái tim
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
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/pochita.jpg',
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          );
                        },
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
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pink.withOpacity(1.0),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.favorite_border,
                    color: AppColors.pinkSubColor,
                  ),
                ),
              ),
            ],
          ),

          // Nội dung bên dưới
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
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
                          '${getAverageRating()}', // Hiển thị số sao trung bình phần nguyên
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
    );
  }
}
