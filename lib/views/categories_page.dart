// views/categories_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/category.dart';
import 'package:recipe_app/views/widgets/category_card.dart';
import '../viewmodels/categories_viewmodel.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoriesViewModel _viewModel = CategoriesViewModel();
  late Future<List<Category>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _viewModel.getCategories();
  }

  void _selectCategory(String categoryId) {
    Navigator.pushNamed(context, '/trending', arguments: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: FutureBuilder<List<Category>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _selectCategory(category.id),
                  child: CategoryCard(category: category),
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
