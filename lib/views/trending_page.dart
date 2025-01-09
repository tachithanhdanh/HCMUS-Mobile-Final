// views/trending_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';
import '../viewmodels/trending_viewmodel.dart';
import 'recipe_details_page.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  final TrendingViewModel _viewModel = TrendingViewModel();
  late Future<List<Recipe>> _recipes;
  late String _categoryId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoryId = ModalRoute.of(context)!.settings.arguments as String;
    _recipes = _viewModel.getRecipesByCategory(_categoryId);
  }

  void _selectRecipe(String recipeId) {
    Navigator.pushNamed(context, '/recipe_details', arguments: recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trending Recipes')),
      body: FutureBuilder<List<Recipe>>(
        future: _recipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _selectRecipe(recipe.id),
                  child: RecipeCard(recipe: recipe),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
