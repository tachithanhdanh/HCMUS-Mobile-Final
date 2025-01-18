import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import '../widgets/categories_icon_actions.dart';
import 'categories_details_page.dart';
import 'package:recipe_app/enums/category.dart';

class CategoriesPage extends StatelessWidget {
  final List<Category> _categories = Category.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  "Categories",
                  style: TextStyle(
                    color: AppColors.redPinkMain,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CategoriesIconActions()
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Chia thành 2 cột
                  crossAxisSpacing: 16.0, // Khoảng cách giữa các cột
                  mainAxisSpacing: 16.0, // Khoảng cách giữa các hàng
                  childAspectRatio: 1.15, // Tỉ lệ chiều cao/chiều rộng của mỗi ô
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CategoriesDetailPage(
                            selectedCategory: _categories[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.asset(
                              '/images/${_categories[index].name}.jpg', // Tạo đường dẫn ảnh tự động
                              fit: BoxFit.cover,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  // height: 120,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _categories[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.redPinkMain,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
