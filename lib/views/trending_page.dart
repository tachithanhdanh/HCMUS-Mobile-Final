import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';

class TrendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.transparent, // Màu nền trong suốt
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header (Instead of AppBar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                      onPressed: () {
                        Navigator.of(context).pop(); // Back action
                      },
                    ),
                    Text(
                      "Trending Recipes",
                      style: TextStyle(
                        color: AppColors.redPinkMain,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _buildIconButton(context, Icons.search, () {}),
                        const SizedBox(width: 8),
                        _buildIconButton(
                            context, Icons.notifications_none, () {}),
                        const SizedBox(width: 8),
                        _buildIconButton(context, Icons.account_circle, () {}),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nội dung Trending Page
                // Your Recipes Section
                Container(
                  width: double.infinity, // Chiếm toàn bộ chiều ngang
                  decoration: BoxDecoration(
                    color: AppColors.redPinkMain, // Màu nền
                    borderRadius: BorderRadius.circular(12), // Bo viền
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Text(
                        "Your Recipes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Chữ màu trắng
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pink,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.pinkSubColor),
        iconSize: 20,
      ),
    );
  }
}
