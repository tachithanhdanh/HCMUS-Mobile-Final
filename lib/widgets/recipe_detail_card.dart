import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'dart:convert';

class RecipeDetailCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  // Hàm tính trung bình số sao
  double getAverageRating() {
    if (recipe.reviews.isEmpty) return 0;
    int totalRatings =
        recipe.reviews.map((review) => review.rating).reduce((a, b) => a + b);
    double average = totalRatings.toDouble() / recipe.reviews.length;
    return double.parse(average.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final double averageRating = getAverageRating();
    final int reviewCount = recipe.reviews.length;

    return GestureDetector(
      onTap: () {
        // Chuyển hướng đến trang chi tiết công thức
        Navigator.pushNamed(
          context,
          '/recipe_reviews',
          arguments: recipe.id,
        );
      },
      child: Card(
        color: AppColors.redPinkMain, // Màu nền đỏ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh của recipe
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: recipe.imageUrl.isNotEmpty
                  ? (recipe.imageUrl.startsWith(
                          'data:image/') // Kiểm tra nếu là chuỗi Base64
                      ? Image.memory(
                          base64Decode(
                            recipe.imageUrl.split(',').last, // Giải mã Base64
                          ),
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        )
                      : Image.network(
                          recipe.imageUrl, // URL hình ảnh thông thường
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ))
                  : Image.asset(
                      'assets/images/pochita.jpg', // Hình mặc định
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                    ),
            ),

            // Nội dung dưới hình ảnh
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tên của recipe
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Màu chữ trắng
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Số sao trung bình và số lượng reviews
                  Row(
                    children: [
                      // Biểu tượng sao
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white, // Biểu tượng màu trắng
                      ),
                      const SizedBox(width: 4),
                      // Số sao trung bình
                      Text(
                        averageRating.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Màu chữ trắng
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Biểu tượng reviews
                      Icon(
                        Icons.comment,
                        size: 16,
                        color: Colors.white, // Biểu tượng màu trắng
                      ),
                      const SizedBox(width: 4),
                      // Số lượng reviews
                      Text(
                        reviewCount.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Màu chữ trắng
                        ),
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
