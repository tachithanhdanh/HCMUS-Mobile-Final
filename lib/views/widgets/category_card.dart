// views/widgets/category_card.dart
import 'package:flutter/material.dart';
import '../../enums/category.dart'; // Import enum Category

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả về URL icon theo category
    final Map<Category, String> categoryIcons = {
      Category.Dessert: 'assets/icons/dessert.png',
      Category.MainCourse: 'assets/icons/main_course.png',
      Category.Appetizer: 'assets/icons/appetizer.png',
      Category.Beverage: 'assets/icons/beverage.png',
      Category.Snack: 'assets/icons/snack.png',
      Category.Other: 'assets/icons/other.png',
    };

    final iconUrl = categoryIcons[category] ?? 'assets/icons/default.png';

    return Card(
      child: Column(
        children: [
          Image.asset(
            iconUrl,
            height: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              category.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
