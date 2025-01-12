// views/categories_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/enums/category.dart'; // Import enum Category
import 'package:recipe_app/views/widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  final List<Category> _categories = Category.values; // Sử dụng enum

  void _selectCategory(BuildContext context, Category category) {
    Navigator.pushNamed(context, '/trending', arguments: category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () => _selectCategory(context, category),
            child: CategoryCard(category: category),
          );
        },
      ),
    );
  }
}
