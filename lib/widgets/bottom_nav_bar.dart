import 'package:flutter/material.dart';
import 'package:recipe_app/app.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/mock_data.dart';
import 'package:recipe_app/views/add_recipe_page.dart';
import 'package:recipe_app/views/categories_page.dart';
import 'package:recipe_app/views/community_page.dart';
import 'package:recipe_app/views/home_page.dart';
import 'package:recipe_app/views/profile_page.dart'; // Import AppColors

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy tên route hiện tại
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Định nghĩa các route tương ứng với BottomNavigationBar
    final routeMapping = {
      0: '/home',
      1: '/community',
      2: '/add_recipe',
      3: '/categories',
      4: '/profile',
    };

    // Xác định index của route hiện tại
    final currentIndex =
        routeMapping.values.toList().indexOf(currentRoute ?? "");

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.redPinkMain,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex >= 0 ? currentIndex : 0,
      onTap: (index) {
        final targetRoute = routeMapping[index];
        if (targetRoute != null && targetRoute != currentRoute) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PageWithNavBar(
                child: _buildPage(targetRoute),
              ),
              settings: RouteSettings(name: targetRoute), // Cung cấp tên route
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
        BottomNavigationBarItem(
            icon: Icon(Icons.category), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget _buildPage(String routeName) {
    switch (routeName) {
      case '/home':
        return HomePage();
      case '/community':
        return CommunityPage();
      case '/add_recipe':
        return AddRecipePage();
      case '/categories':
        return CategoriesPage();
      case '/profile':
        return ProfilePage();
      default:
        throw Exception('Invalid route: $routeName');
    }
  }
}
