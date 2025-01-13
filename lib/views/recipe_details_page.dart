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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recipe saved successfully!')),
    );
  }

  void _shareRecipe(String recipeId) {
    _viewModel.shareRecipe(recipeId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recipe shared successfully!')),
    );
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị hình ảnh
                  recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, size: 200);
                          },
                        )
                      : Icon(Icons.image, size: 200),
                  const SizedBox(height: 16),

                  // Tiêu đề và mô tả
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Thành phần
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map((ingredient) {
                    return ListTile(
                      leading: Icon(Icons.check, color: Colors.green),
                      title: Text(ingredient),
                    );
                  }).toList(),

                  const SizedBox(height: 16),

                  // Các bước thực hiện
                  Text(
                    'Steps',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                        backgroundColor: Colors.blueAccent,
                      ),
                      title: Text(step),
                    );
                  }).toList(),

                  const SizedBox(height: 16),

                  // Nút lưu và chia sẻ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _saveRecipe('userId', recipe.id),
                        child: Text('Save'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => _shareRecipe(recipe.id),
                        child: Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading recipe details'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
