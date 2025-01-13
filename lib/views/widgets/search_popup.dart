import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/recipe.dart';

class SearchPopup extends StatefulWidget {
  final List<Recipe> recommendedRecipes;

  const SearchPopup({required this.recommendedRecipes, Key? key})
      : super(key: key);

  @override
  _SearchPopupState createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  String searchQuery = ''; // Biến lưu nội dung tìm kiếm

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bo góc cho khung
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Kích thước vừa nội dung
          children: [
            // Tiêu đề Search
            Text(
              "Search",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.redPinkMain,
              ),
            ),
            const SizedBox(height: 16),

            // TextField để nhập nội dung tìm kiếm
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Cập nhật nội dung tìm kiếm
                });
              },
              decoration: InputDecoration(
                hintText: "Type to search...",
                filled: true,
                fillColor: AppColors.pinkSubColor.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.redPinkMain),
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Recipes
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recommended Recipes",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redPinkMain,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Chip danh sách Recommended Recipes
            Wrap(
              spacing: 8.0, // Khoảng cách ngang giữa các chip
              runSpacing: 8.0, // Khoảng cách dọc giữa các dòng chip
              children: widget.recommendedRecipes
                  .where((recipe) => recipe.title.toLowerCase().contains(
                      searchQuery.toLowerCase())) // Lọc theo nội dung tìm kiếm
                  .map((recipe) {
                return Chip(
                  label: Text(recipe.title),
                  backgroundColor: AppColors.pinkSubColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: AppColors.redPinkMain,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Nút Search
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Đóng pop-up
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redPinkMain,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
