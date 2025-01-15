// views/search_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/widgets/recipe_card.dart';
import '../viewmodels/search_viewmodel.dart';
import 'recipe_details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchViewModel _viewModel = SearchViewModel();
  List<Recipe> _searchResults = [];
  TextEditingController _controller = TextEditingController();

  void _search(String query) async {
    List<Recipe> results = await _viewModel.searchRecipes(query);
    setState(() {
      _searchResults = results;
    });
  }

  void _selectRecipe(String recipeId) {
    Navigator.pushNamed(context, '/recipe_details', arguments: recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Recipes')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _search(_controller.text),
                ),
              ),
              onSubmitted: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final recipe = _searchResults[index];
                return GestureDetector(
                  onTap: () => _selectRecipe(recipe.id),
                  child: RecipeCard(
                      recipe: recipe,
                      isFavorite: false,
                      onFavoriteToggle: () {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
