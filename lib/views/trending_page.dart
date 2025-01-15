import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/widgets/icon_actions.dart';
import 'package:recipe_app/widgets/recipe_card.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/widgets/trending_recipe_card.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/services/user_service.dart';
import 'package:recipe_app/providers/user_provider.dart';

class TrendingPage extends StatefulWidget {
  TrendingPage({Key? key}) : super(key: key);

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  List<Recipe> sortedRecipes = []; // Khởi tạo danh sách rỗng
  UserProfile? currentUser;
  Recipe? mostReviewedRecipe; // Đặt nullable vì có thể chưa có dữ liệu
  List<UserProfile> authors = [];
  bool isLoading = true;

  final RecipeService _recipeService = RecipeService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUser = userProvider.currentUser;

    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Fetch all recipes
      final recipes = await _recipeService.fetchAllRecipes();

      // Fetch authors based on recipe authorIds
      final userIds = recipes.map((recipe) => recipe.authorId).toSet().toList();
      final fetchedAuthors = await _userService.fetchAuthorsByUserIds(userIds);

      // Sort recipes by reviews
      final sorted = [...recipes]
        ..sort((a, b) => b.reviews.length.compareTo(a.reviews.length));

      setState(() {
        sortedRecipes = sorted;
        mostReviewedRecipe = sorted.first;
        authors = fetchedAuthors;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.transparent,
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
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      "Trending Recipes",
                      style: TextStyle(
                        color: AppColors.redPinkMain,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconActions(
                      recipes: sortedRecipes,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Most Reviewed Recipe Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.redPinkMain,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Most Reviewed",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecipeCard(
                        recipe: mostReviewedRecipe!,
                        isFavorite: currentUser?.favoriteRecipes
                                .contains(mostReviewedRecipe!.id) ??
                            false,
                        onFavoriteToggle: () {
                          setState(() {
                            if (currentUser?.favoriteRecipes
                                    .contains(mostReviewedRecipe!.id) ??
                                false) {
                              currentUser?.favoriteRecipes
                                  .remove(mostReviewedRecipe!.id);
                            } else {
                              currentUser?.favoriteRecipes
                                  .add(mostReviewedRecipe!.id);
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
                    ...sortedRecipes.map((recipe) {
                      final author = authors.firstWhere(
                        (user) => user.id == recipe.authorId,
                        orElse: () => UserProfile(
                          id: '',
                          name: 'Unknown',
                          email: '',
                          avatarUrl: '',
                          favoriteRecipes: [],
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TrendingRecipeCard(
                          recipe: recipe,
                          isFavorite: currentUser?.favoriteRecipes
                                  .contains(recipe.id) ??
                              false,
                          onFavoriteToggle: () {
                            setState(() {
                              if (currentUser?.favoriteRecipes
                                      .contains(recipe.id) ??
                                  false) {
                                currentUser?.favoriteRecipes.remove(recipe.id);
                              } else {
                                currentUser?.favoriteRecipes.add(recipe.id);
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
