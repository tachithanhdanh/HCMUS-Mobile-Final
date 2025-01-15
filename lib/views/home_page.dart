import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/widgets/icon_actions.dart';
import 'package:recipe_app/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  final UserProfile currentUser;
  final List<Recipe> allRecipes;

  HomePage({
    required this.currentUser,
    required this.allRecipes,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserProfile currentUser;
  late List<Recipe> trendingRecipes;
  late List<Recipe> yourRecipes;
  late List<Recipe> favoriteRecipes;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;

    // Lọc danh sách công thức dựa trên tiêu chí
    trendingRecipes =
        widget.allRecipes; // Có thể thêm logic lọc công thức thịnh hành
    yourRecipes = widget.allRecipes
        .where((recipe) => recipe.authorId == currentUser.id)
        .toList();
    favoriteRecipes = widget.allRecipes
        .where((recipe) => currentUser.favoriteRecipes.contains(recipe.id))
        .toList();
  }

  void _toggleFavorite(String recipeId) {
    setState(() {
      if (currentUser.favoriteRecipes.contains(recipeId)) {
        currentUser.favoriteRecipes.remove(recipeId);
      } else {
        currentUser.favoriteRecipes.add(recipeId);
      }
      // Cập nhật danh sách yêu thích sau khi thay đổi
      favoriteRecipes = widget.allRecipes
          .where((recipe) => currentUser.favoriteRecipes.contains(recipe.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bao bọc tất cả trừ "Your Recipes" trong Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header (Instead of AppBar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dòng đầu tiên: Hi, user name và icon bên phải
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text: Hi, user name
                            Text(
                              "Hi! ${currentUser.name}",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Icon Actions
                            IconActions(
                              recipes: [...trendingRecipes, ...yourRecipes],
                            ),
                          ],
                        ),
                        // Dòng thứ hai: What are you cooking today
                        Text(
                          "What are you cooking today",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Trending Recipe Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tiêu đề
                      Text(
                        "Trending Recipe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.redPinkMain,
                        ),
                      ),
                      // Dòng chữ "View More" với biểu tượng
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/trending');
                        },
                        child: Row(
                          children: [
                            Text(
                              "View More",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.redPinkMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                width: 4), // Khoảng cách giữa chữ và biểu tượng
                            Icon(
                              Icons.arrow_forward, // Biểu tượng mũi tên
                              size: 16,
                              color: AppColors.redPinkMain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTrendingRecipes(trendingRecipes),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Your Recipes Section
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
                    "Your Recipes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách Recipes
                  _buildYourRecipes(context, yourRecipes),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity, // Chiếm toàn bộ chiều ngang
              decoration: BoxDecoration(
                color: AppColors.redPinkMain, // Màu nền
                borderRadius: BorderRadius.circular(12), // Bo viền
              ),
              padding: const EdgeInsets.all(16.0), // Khoảng cách bên trong
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    "Favorites",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách Recipes
                  _buildFavorites(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingRecipes(List<Recipe> recipes) {
    // Tìm công thức có nhiều lượt đánh giá nhất
    final mostReviewedRecipe =
        recipes.reduce((a, b) => (a.reviews.length > b.reviews.length) ? a : b);

    return RecipeCard(
      recipe: mostReviewedRecipe,
      isFavorite: currentUser.favoriteRecipes.contains(mostReviewedRecipe.id),
      onFavoriteToggle: () => _toggleFavorite(mostReviewedRecipe.id),
    );
  }

  Widget _buildYourRecipes(BuildContext context, List<Recipe> recipes) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recipes.map((recipe) {
          return Container(
            width: MediaQuery.of(context).size.width / 2 -
                24, // Chiều rộng vừa đủ để hiển thị 2 thẻ
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: RecipeCard(
              recipe: recipe,
              isFavorite: currentUser.favoriteRecipes.contains(recipe.id),
              onFavoriteToggle: () => _toggleFavorite(recipe.id),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFavorites() {
    final recipes = favoriteRecipes;
    if (recipes.isEmpty) {
      return Text("No favorites yet.");
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recipes.map((recipe) {
          return Container(
            width: MediaQuery.of(context).size.width / 2 -
                24, // Chiều rộng vừa đủ để hiển thị 2 thẻ
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: RecipeCard(
              recipe: recipe,
              isFavorite: currentUser.favoriteRecipes.contains(recipe.id),
              onFavoriteToggle: () => _toggleFavorite(recipe.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
