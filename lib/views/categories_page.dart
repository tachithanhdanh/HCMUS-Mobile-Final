import 'package:flutter/material.dart';
import 'package:recipe_app/models/category.dart';
import 'package:recipe_app/views/widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock data
    final categories = [
      Category(id: '1', name: 'Italian', iconUrl: ''),
      Category(id: '2', name: 'Mexican', iconUrl: ''),
    ];

    void _selectCategory(String categoryId) {
      Navigator.pushNamed(context, '/trending', arguments: categoryId);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => _selectCategory(category.id),
            child: CategoryCard(category: category),
          );
        },
      ),
    );
  }
}
