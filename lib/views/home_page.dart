import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/providers/user_provider.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/services/user_service.dart';
import 'package:recipe_app/widgets/icon_actions.dart';
import 'package:recipe_app/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile? currentUser;
  List<String> currentRecipes = [];
  Recipe? trendingRecipe;
  List<Recipe> yourRecipes = [];
  List<Recipe> favoriteRecipes = [];
  List<Recipe> allRecipes = [];
  bool isLoading = true; // Theo dõi trạng thái tải dữ liệu
  bool hasShownRecipeDialog = false;

  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> _showRandomRecipeOnLogin() async {
    if (hasShownRecipeDialog) return; // Không hiển thị lại nếu đã hiện

    Recipe? randomRecipe = await _recipeService.fetchRandomRecipe();
    if (randomRecipe != null) {
      _showRecipeDialog(randomRecipe);
      hasShownRecipeDialog = true; // Đánh dấu dialog đã hiện
    }
  }

  void _showRecipeDialog(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
            onTap: () {
              // Navigate to the Recipe Details Page
              Navigator.pushNamed(
                context,
                '/recipe_details',
                arguments: recipe.id, // Pass the recipe ID as an argument
              );
            },
            child: AlertDialog(
              title: Text(recipe.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(recipe.imageUrl),
                  const SizedBox(height: 10),
                  Text("Description: ${recipe.description}"),
                  const SizedBox(height: 10),
                  Text("Cook Time: ${recipe.cookTime}"),
                  const SizedBox(height: 10),
                  Text("Difficulty: ${recipe.difficulty.name}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            ));
      },
    );
  }

  Future<void> initAsync() async {
    currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;

    if (currentUser == null) {
      setState(() {
        isLoading = false; // Ngừng tải nếu không có user
      });
      return;
    }

    await _loadData(); // Chờ dữ liệu được tải xong

    await _showRandomRecipeOnLogin();
    setState(() {
      isLoading = false; // Dữ liệu đã tải xong
    });
  }

  Future<void> _loadData() async {
    if (currentUser == null) {
      return; // Không có user, không tải dữ liệu
    }

    try {
      // Lấy danh sách công thức thịnh hành
      final trending = await _recipeService.fetchMostTrendingRecipe();

      final _allRecipes = await _recipeService.fetchAllRecipes();

      // Lấy danh sách công thức của User hiện tại
      final userRecipes =
          await _recipeService.fetchRecipesByUserId(currentUser!.id);

      final current = currentUser!.favoriteRecipes;

      // Lọc danh sách công thức yêu thích
      final favorites = _allRecipes.where((recipe) {
        return currentUser!.favoriteRecipes.contains(recipe.id);
      }).toList();

      setState(() {
        trendingRecipe = trending;
        yourRecipes = userRecipes;
        favoriteRecipes = favorites;
        allRecipes = _allRecipes;
        currentRecipes = current;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void updateRecipes() {
    setState(() {
      currentUser =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      // Cập nhật danh sách yêu thích từ allRecipes
      favoriteRecipes = allRecipes.where((recipe) {
        return currentUser?.favoriteRecipes.contains(recipe.id) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(), // Hiển thị khi đang tải
      );
    }

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login_signup');
      });
      return SizedBox.shrink(); // Prevent further widget building
    }

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
                              "Hi! ${currentUser!.name}",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Icon Actions
                            IconActions(
                              recipes: [...allRecipes],
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
                        onTap: () async {
                          Navigator.of(context).pushNamed('/trending');
                          // Gọi lại _loadData khi quay về HomePage
                          await _loadData();
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
                  _buildTrendingRecipes(trendingRecipe!),
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
                  _buildFavorites(allRecipes.where((recipe) {
                    return currentRecipes.contains(recipe.id);
                  }).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingRecipes(Recipe mostReviewedRecipe) {
    // Tìm công thức có nhiều lượt đánh giá nhất

    return RecipeCard(
      recipe: mostReviewedRecipe,
      onRecipeUpdated: updateRecipes,
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
              onRecipeUpdated: updateRecipes,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFavorites(List<Recipe> favoriteRecipes) {
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
              onRecipeUpdated: updateRecipes,
            ),
          );
        }).toList(),
      ),
    );
  }
}
