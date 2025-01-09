// views/recipe_details_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import '../viewmodels/recipe_details_viewmodel.dart';

class RecipeDetailsPage extends StatefulWidget {
  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  final RecipeDetailsViewModel _viewModel = RecipeDetailsViewModel();
  late Future<Recipe> _recipe;
  late String _recipeId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipeId = ModalRoute.of(context)!.settings.arguments as String;
    _recipe = _viewModel.getRecipeDetails(_recipeId);
  }

  void _saveRecipe(String userId, String recipeId) {
    _viewModel.saveRecipe(userId, recipeId);
    // Hiển thị thông báo thành công
  }

  void _shareRecipe(String recipeId) {
    _viewModel.shareRecipe(recipeId);
    // Thực hiện chia sẻ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Details')),
      body: FutureBuilder<Recipe>(
        future: _recipe,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(recipe.imageUrl),
                  Text(recipe.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  // Hiển thị thành phần
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.check),
                        title: Text(recipe.ingredients[index]),
                      );
                    },
                  ),
                  // Hiển thị hướng dẫn
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipe.instructions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text('${index + 1}.'),
                        title: Text(recipe.instructions[index]),
                      );
                    },
                  ),
                  // Nút lưu và chia sẻ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _saveRecipe('userId', recipe.id),
                        child: Text('Save'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => _shareRecipe(recipe.id),
                        child: Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
