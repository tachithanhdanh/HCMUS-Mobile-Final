// views/widgets/category_card.dart
import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(category.iconUrl),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(category.name, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
