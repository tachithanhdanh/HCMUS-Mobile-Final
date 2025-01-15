import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/widgets/icon_actions.dart';
import 'package:recipe_app/widgets/recipe_card.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/widgets/trending_recipe_card.dart';

class TrendingPage extends StatefulWidget {
  final UserProfile currentUser;
  final List<Recipe> trendingRecipes;
  final List<UserProfile> authors;

  TrendingPage({
    required this.currentUser,
    required this.trendingRecipes,
    required this.authors,
  });

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  late List<Recipe> sortedRecipes;
  late UserProfile currentUser;
  late Recipe mostReviewedRecipe;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;

    // Sắp xếp danh sách công thức theo số lượng đánh giá giảm dần
    sortedRecipes = [...widget.trendingRecipes]
      ..sort((a, b) => b.reviews.length.compareTo(a.reviews.length));

    // Tìm công thức có nhiều lượt đánh giá nhất
    mostReviewedRecipe = sortedRecipes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.transparent, // Màu nền trong suốt
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header (Instead of AppBar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                      onPressed: () {
                        Navigator.of(context).pop(); // Back action
                      },
                    ),
                    Text(
                      "Trending Recipes",
                      style: TextStyle(
                        color: AppColors.redPinkMain,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Custom Icon Actions
                    IconActions(
                      recipes: [...widget.trendingRecipes],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nội dung Trending Page
                Container(
                  width: double.infinity, // Chiếm toàn bộ chiều ngang
                  decoration: BoxDecoration(
                    color: AppColors.redPinkMain, // Màu nền
                    borderRadius: BorderRadius.circular(12), // Bo viền
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Text(
                        "Most Reviewed", // Tiêu đề
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Chữ màu trắng
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Hiển thị recipe có nhiều lượt reviewed nhất
                      RecipeCard(
                        recipe: mostReviewedRecipe,
                        isFavorite: currentUser.favoriteRecipes
                            .contains(mostReviewedRecipe.id),
                        onFavoriteToggle: () {
                          setState(() {
                            if (currentUser.favoriteRecipes
                                .contains(mostReviewedRecipe.id)) {
                              currentUser.favoriteRecipes
                                  .remove(mostReviewedRecipe.id);
                            } else {
                              currentUser.favoriteRecipes
                                  .add(mostReviewedRecipe.id);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // List of Recipes Sorted by Reviews
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Danh sách các recipe
                    ...sortedRecipes.map((recipe) {
                      // Lấy thông tin tác giả
                      final author = widget.authors
                          .firstWhere((user) => user.id == recipe.authorId);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TrendingRecipeCard(
                          recipe: recipe,
                          isFavorite:
                              currentUser.favoriteRecipes.contains(recipe.id),
                          onFavoriteToggle: () {
                            setState(() {
                              if (currentUser.favoriteRecipes
                                  .contains(recipe.id)) {
                                currentUser.favoriteRecipes.remove(recipe.id);
                              } else {
                                currentUser.favoriteRecipes.add(recipe.id);
                              }
                            });
                          },
                          authorName: author.name,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
