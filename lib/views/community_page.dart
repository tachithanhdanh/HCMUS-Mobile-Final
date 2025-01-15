import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/community_recipe_card.dart';
import '../../models/recipe.dart';
import '../../models/user_profile.dart';
import '../../constants/colors.dart';

class CommunityPage extends StatefulWidget {
  final UserProfile currentUser;
  final List<Recipe> communityRecipes;
  final List<UserProfile> authors;
  // final Function(Recipe) onToggleFavorite;

  CommunityPage({
    required this.currentUser,
    required this.communityRecipes,
    required this.authors,
    // required this.onToggleFavorite,
  });

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String selectedFilter = "Top"; // Default filter
  late List<Recipe> filteredRecipes;
  late UserProfile currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    filteredRecipes = [
      ...widget.communityRecipes
    ]; // Initialize with original list
    _applyFilter(); // Apply default filter
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

  void onToggleFavorite(Recipe recipe) {
    setState(() {
      if (currentUser.favoriteRecipes.contains(recipe.id)) {
        // Nếu đã yêu thích, xóa khỏi danh sách
        currentUser.favoriteRecipes.remove(recipe.id);
      } else {
        // Nếu chưa yêu thích, thêm vào danh sách
        currentUser.favoriteRecipes.add(recipe.id);
      }
    });
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
                      Row(
                        children: [
                          _buildIconButton(context, Icons.search, () {}),
                          const SizedBox(width: 8),
                          _buildIconButton(
                              context, Icons.notifications_none, () {}),
                          const SizedBox(width: 8),
                          _buildIconButton(
                              context, Icons.account_circle, () {}),
                        ],
                      ),
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
                      final author = widget.authors
                          .firstWhere((user) => user.id == recipe.authorId);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CommunityRecipeCard(
                          recipe: recipe,
                          author: author,
                          isFavorite: widget.currentUser.favoriteRecipes
                              .contains(recipe.id),
                          onFavoriteToggle: () => onToggleFavorite(recipe),
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

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pink,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.pinkSubColor),
        iconSize: 20,
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
