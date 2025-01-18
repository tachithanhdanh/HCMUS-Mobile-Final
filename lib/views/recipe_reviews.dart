import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày
import '../models/recipe.dart';
import '../models/user_profile.dart';
import '../services/recipe_service.dart'; // Để gọi hàm fetchRecipeDetails
import '../constants/colors.dart';
import 'dart:convert';
import '../services/user_service.dart'; // Để gọi hàm fetchUserById
import '../models/review.dart';

class RecipeReviewsPage extends StatefulWidget {
  @override
  _RecipeReviewsPageState createState() => _RecipeReviewsPageState();
}

class _RecipeReviewsPageState extends State<RecipeReviewsPage> {
  late String recipeId; // Lưu recipeId được truyền qua arguments
  late Future<Recipe> recipe; // Lưu thông tin Recipe được fetch
  final RecipeService _recipeService = RecipeService();
  final UserService _userService = UserService();
  late Future<UserProfile?> _authorProfile;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lấy recipeId từ arguments
    recipeId = ModalRoute.of(context)!.settings.arguments as String;

    // Fetch thông tin Recipe
    recipe = _recipeService.fetchRecipeDetails(recipeId);
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final totalRating = reviews.fold<int>(
      0,
      (sum, review) => sum + review.rating,
    );
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(
              color: AppColors.redPinkMain, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.redPinkMain),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Recipe>(
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load recipe: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Recipe not found'));
          }

          final Recipe recipeData = snapshot.data!;
          final averageRating =
              _calculateAverageRating(recipeData.reviews).toStringAsFixed(1);

          _authorProfile = _userService.fetchUserById(recipeData.authorId);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: AppColors.redPinkMain,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hình ảnh công thức
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: recipeData.imageUrl.startsWith(
                                    'data:image/') // Kiểm tra Base64
                                ? Image.memory(
                                    base64Decode(
                                        recipeData.imageUrl.split(',').last),
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/pochita.jpg', // Ảnh mặc định nếu không có Base64
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(width: 16),
                          // Thông tin công thức
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tên công thức
                                Text(
                                  recipeData.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Đánh giá và số lượt đánh giá
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _calculateAverageRating(
                                                  recipeData.reviews)
                                              .toStringAsFixed(
                                                  1), // Hiển thị số trung bình sao
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                4), // Khoảng cách giữa số và ngôi sao
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${recipeData.reviews.length} Reviews)',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    FutureBuilder<UserProfile?>(
                                      future: _userService.fetchUserById(recipeData
                                          .authorId), // Fetch thông tin tác giả
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors
                                                .grey, // Placeholder loading
                                          );
                                        } else if (snapshot.hasError) {
                                          return const CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                Colors.red, // Placeholder error
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return const CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors
                                                .grey, // Placeholder nếu không tìm thấy user
                                          );
                                        }

                                        final author = snapshot
                                            .data!; // Lấy thông tin tác giả

                                        return Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: author.avatarUrl
                                                      .startsWith('data:image/')
                                                  ? MemoryImage(
                                                      base64Decode(author
                                                          .avatarUrl
                                                          .split(',')
                                                          .last),
                                                    )
                                                  : AssetImage(
                                                          'assets/images/gojo_satoru.png')
                                                      as ImageProvider,
                                              radius: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  author
                                                      .name, // Hiển thị username của tác giả
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  author
                                                      .email, // Hoặc các thông tin khác của tác giả
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                // Nút Add Review
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/leave_a_review',
                                      arguments: recipeData.id,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.redPinkMain,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add Review',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Comments Section
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Danh sách Review
                  Column(
                    children: recipeData.reviews.map((review) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: FutureBuilder<UserProfile?>(
                          future: _userService.fetchUserById(
                              review.userId), // Gọi hàm fetch thông tin user
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Loading state
                            } else if (snapshot.hasError) {
                              return const Text(
                                  'Failed to load user'); // Error state
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Text(
                                  'User not found'); // User không tồn tại
                            }

                            final user =
                                snapshot.data!; // Lấy thông tin UserProfile

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: user.avatarUrl.startsWith(
                                              'data:image/') // Kiểm tra Base64
                                          ? MemoryImage(
                                              base64Decode(user.avatarUrl
                                                  .split(',')
                                                  .last), // Decode Base64
                                            )
                                          : AssetImage(
                                                  'assets/images/gojo_satoru.png')
                                              as ImageProvider, // Dùng asset nếu không phải Base64
                                      radius: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name, // Hiển thị tên của user
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('yyyy-MM-dd – kk:mm')
                                                .format(review
                                                    .createdAt), // Hiển thị thời gian
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.content,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < review.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
