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
  late Future<List<User>> _topChefs;

  @override
  void initState() {
    super.initState();
    _trendingRecipes = _viewModel.getTrendingRecipes();
    _topChefs = _viewModel.getTopChefs();
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
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((recipe) {
                      return RecipeCard(recipe: recipe);
                    }).toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            // Hiển thị Top Chefs
            FutureBuilder<List<User>>(
              future: _topChefs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((chef) {
                      return TopChefCard(chef: chef);
                    }).toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Text(
  //         'This is Home page', // Nội dung hiển thị
  //         style: TextStyle(
  //           fontSize: 24, // Kích thước chữ
  //           fontWeight: FontWeight.bold, // Chữ đậm
  //           color: Colors.black, // Màu chữ
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
