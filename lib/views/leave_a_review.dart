import 'package:flutter/material.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'dart:convert';
import '../constants/colors.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import 'package:recipe_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/user_profile.dart';

class LeaveReviewPage extends StatefulWidget {
  @override
  _LeaveReviewPageState createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  final RecipeService _recipeService = RecipeService();
  final ReviewService _reviewService = ReviewService();
  late String recipeId;
  late Future<Map<String, dynamic>> recipeData;
  late UserProvider userProvider;
  late UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUser = userProvider.currentUser;
  }

  int _rating = 0; // Lưu đánh giá số sao
  final TextEditingController _reviewController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lấy recipeId từ arguments
    recipeId = ModalRoute.of(context)!.settings.arguments as String;

    // Fetch thông tin công thức
    recipeData = _fetchRecipeData(recipeId);
  }

  Future<Map<String, dynamic>> _fetchRecipeData(String recipeId) async {
    final recipe = await _recipeService.fetchRecipeDetails(recipeId);
    return {
      'title': recipe.title,
      'imageUrl': recipe.imageUrl,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leave A Review',
          style: TextStyle(
              color: AppColors.redPinkMain, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.redPinkMain),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: recipeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load recipe: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Recipe not found'));
          }

          final data = snapshot.data!;
          final String title = data['title'];
          final String imageUrl = data['imageUrl'];

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Recipe Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: imageUrl.startsWith('data:image/')
                        ? Image.memory(
                            base64Decode(imageUrl.split(',').last),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Recipe Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brownPod,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Star Rating
                  Column(
                    children: [
                      StatefulBuilder(
                        builder: (context, setStarState) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border_outlined,
                                color: AppColors.redPinkMain,
                                size: 32,
                              ),
                              onPressed: () {
                                setStarState(() {
                                  _rating = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                      ),
                      const Text(
                        'Your overall rating',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Leave Us Review
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Leave us Review!',
                      filled: true,
                      fillColor: AppColors.redPinkMain.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cancel and Submit Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Trở lại màn hình trước
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red), // Viền đỏ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red, // Chữ đỏ
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // Khoảng cách giữa hai nút
                      ElevatedButton(
                        onPressed: () async {
                          if (_rating == 0 || _reviewController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please provide a rating and write a review.'),
                              ),
                            );
                            return;
                          }

                          try {
                            // Tạo Review mới
                            final review = Review(
                              id: '', // Firestore sẽ tự cấp phát ID
                              userId: currentUser!.id,
                              content: _reviewController.text,
                              rating: _rating,
                              createdAt: DateTime.now(),
                            );

                            // Gọi hàm thêm review vào Firebase
                            await _reviewService.addReview(recipeId, review);

                            // Hiển thị thông báo thành công
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Review added successfully!')),
                            );

                            // Quay lại màn hình trước
                            Navigator.pop(context);
                          } catch (e) {
                            // Hiển thị thông báo lỗi
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to add review: ${e.toString()}')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redPinkMain,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
