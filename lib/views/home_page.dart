// views/home_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';
import 'package:recipe_app/views/widgets/top_chef_card.dart';
import '../viewmodels/home_viewmodel.dart';
import 'widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = HomeViewModel();
  late Future<List<Recipe>> _trendingRecipes;
  late Future<List<UserProfile>> _topChefs;

  @override
  void initState() {
    super.initState();
    _trendingRecipes = _viewModel.getTrendingRecipes();
    _topChefs = _viewModel.getTopChefs(); // Chuyển sang kiểu UserProfile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hiển thị Trending Recipes
            FutureBuilder<List<Recipe>>(
              future: _trendingRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((recipe) {
                      return RecipeCard(recipe: recipe);
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading recipes'));
                } else {
                  return Center(child: Text('No trending recipes available'));
                }
              },
            ),
            const SizedBox(height: 16),

            // Hiển thị Top Chefs
            FutureBuilder<List<UserProfile>>(
              future: _topChefs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((chef) {
                      return TopChefCard(
                        chef: chef, // Truyền UserProfile trực tiếp
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading chefs'));
                } else {
                  return Center(child: Text('No top chefs available'));
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
