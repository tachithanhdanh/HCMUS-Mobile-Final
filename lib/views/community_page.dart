import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/providers/user_provider.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/services/user_service.dart';
import 'package:recipe_app/widgets/community_recipe_card.dart';
import 'package:recipe_app/widgets/icon_actions.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String selectedFilter = "Top"; // Bộ lọc mặc định
  List<Recipe> filteredRecipes = [];
  UserProfile? currentUser;
  List<Recipe> communityRecipes = [];
  List<UserProfile> authors = [];

  final RecipeService _recipeService = RecipeService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUser = userProvider.currentUser;

    if (currentUser == null) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final _recipes = await RecipeService().fetchAllRecipes();
      final _userIds =
          _recipes.map((recipe) => recipe.authorId).toSet().toList();
      final _authors = await UserService().fetchAuthorsByUserIds(_userIds);

      setState(() {
        communityRecipes = _recipes;
        filteredRecipes = List.from(_recipes);
        authors = _authors;
        _applyFilter();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (selectedFilter == "Top") {
        filteredRecipes.sort(
            (a, b) => b.getAverageRating().compareTo(a.getAverageRating()));
      } else if (selectedFilter == "Newest") {
        filteredRecipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else if (selectedFilter == "Oldest") {
        filteredRecipes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }
    });
  }

  Future<void> _loadAuthors() async {
    try {
      final userIds =
          communityRecipes.map((recipe) => recipe.authorId).toSet().toList();
      final authors = await UserService().fetchAuthorsByUserIds(userIds);

      setState(() {
        // Lưu danh sách tác giả để sử dụng trong UI
        this.authors = authors;
      });
    } catch (e) {
      print("Error loading authors: $e");
    }
  }

  void _toggleFavorite(String recipeId) async {
    if (currentUser == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final updatedUser = await UserService().toggleFavoriteRecipe(
        currentUser!.id,
        recipeId,
      );

      userProvider.setUser(updatedUser);
      setState(() {
        currentUser = updatedUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header (Instead of AppBar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: AppColors.redPinkMain),
                        onPressed: () {
                          Navigator.of(context).pop(); // Back action
                        },
                      ),
                      Text(
                        "Community",
                        style: TextStyle(
                          color: AppColors.redPinkMain,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Custom Icon Actions
                      IconActions(recipes: filteredRecipes),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFilterOption("Top"),
                      _buildFilterOption("Newest"),
                      _buildFilterOption("Oldest"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Community Recipes Section
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      final author = authors.firstWhere(
                          (user) => user.id == recipe.authorId,
                          orElse: () => UserProfile(
                                id: '',
                                name: 'Unknown',
                                email: '',
                                avatarUrl: '',
                                favoriteRecipes: [],
                              )); // Xử lý khi không tìm thấy tác giả
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CommunityRecipeCard(
                          recipe: recipe,
                          author: author,
                          isFavorite: currentUser?.favoriteRecipes
                                  .contains(recipe.id) ??
                              false,
                          onFavoriteToggle: () => _toggleFavorite(recipe.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildFilterOption(String filter) {
    final isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.redPinkMain : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.redPinkMain),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.redPinkMain,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

extension on Recipe {
  double getAverageRating() {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }
}
