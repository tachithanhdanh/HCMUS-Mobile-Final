import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/providers/user_provider.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/services/user_service.dart';
import 'package:recipe_app/widgets/categories_recipe_card.dart';
import 'package:recipe_app/widgets/profile_icon_actions.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Recipe> allRecipes = [];
  List<Recipe> favoriteRecipes = [];
  List<Recipe> userAuthoredRecipes = [];
  List<UserProfile> authors = [];
  UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRecipes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      currentUser = userProvider.currentUser;

      if (currentUser != null) {
        final fetchedRecipes = await RecipeService().fetchAllRecipes();
        final userIds = fetchedRecipes.map((recipe) => recipe.authorId).toSet().toList();
        final fetchedAuthors = await UserService().fetchAuthorsByUserIds(userIds);

        setState(() {
          allRecipes = fetchedRecipes;
          favoriteRecipes = fetchedRecipes
              .where((recipe) => currentUser!.favoriteRecipes.contains(recipe.id))
              .toList();
          userAuthoredRecipes =
              fetchedRecipes.where((recipe) => recipe.authorId == currentUser!.id).toList();
          authors = fetchedAuthors;
        });
      }
    } catch (e) {
      // Handle errors if needed
    }
  }

  Future<void> _toggleFavoriteA(String recipeId) async {
    if (currentUser == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUser = userProvider.currentUser;
    try {
      setState(() {
        favoriteRecipes = allRecipes
            .where((recipe) => currentUser!.favoriteRecipes.contains(recipe.id))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    currentUser = userProvider.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      color: AppColors.redPinkMain,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ProfileIconActions()
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Text(
                    'No user information available. Please log in.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                    color: AppColors.redPinkMain,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ProfileIconActions()
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: currentUser!.avatarUrl.startsWith('data:image/') // Kiểm tra Base64
                    ? MemoryImage(
                  base64Decode(currentUser!.avatarUrl.split(',').last),
                )
                    : AssetImage('assets/images/pochita.jpg') as ImageProvider, // Ảnh mặc định nếu không có Base64
                backgroundColor: Colors.grey[200], // Màu nền nếu không có ảnh
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                currentUser!.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                currentUser!.email,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.redPinkMain,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.redPinkMain,
              tabs: [
                Tab(text: "Recipes"),
                Tab(text: "Favorites"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Recipes Tab
                  userAuthoredRecipes.isEmpty
                      ? Center(
                    child: Text(
                      'No recipes authored by you.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: userAuthoredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = userAuthoredRecipes[index];
                      final author = authors.firstWhere(
                            (user) => user.id == recipe.authorId,
                        orElse: () => UserProfile(
                          id: '',
                          name: 'Unknown',
                          email: '',
                          avatarUrl: '',
                        ),
                      );
                      return CategoriesRecipeCard(
                        recipe: recipe,
                        author: author,
                        isFavorite: favoriteRecipes.contains(recipe),
                        onFavoriteToggle: () => _toggleFavoriteA(recipe.id),
                      );
                    },
                  ),
                  // Favorites Tab
                  favoriteRecipes.isEmpty
                      ? Center(
                    child: Text(
                      'No favorite recipes found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : GridView.builder(
                    key: ValueKey(favoriteRecipes.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = favoriteRecipes[index];
                      final author = authors.firstWhere(
                            (user) => user.id == recipe.authorId,
                        orElse: () => UserProfile(
                          id: '',
                          name: 'Unknown',
                          email: '',
                          avatarUrl: '',
                        ),
                      );
                      return CategoriesRecipeCard(
                        recipe: recipe,
                        author: author,
                        isFavorite: true,
                        onFavoriteToggle: () => _toggleFavoriteA(recipe.id),
                      );
                    },
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
