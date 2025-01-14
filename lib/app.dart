import 'package:flutter/material.dart';
import 'package:recipe_app/models/mock_data.dart';
import 'views/home_page.dart';
import 'views/community_page.dart';
import 'views/add_recipe_page.dart';
import 'views/categories_page.dart';
import 'views/profile_page.dart';
import 'constants/colors.dart'; // Import file colors.dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppNavigator(), // Dùng một Navigator riêng quản lý stack
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CommunityPage(
      currentUser: mockUsers[0],
      communityRecipes: mockRecipes,
      authors: mockUsers,
      onToggleFavorite: (recipe) {
        // Handle favorite toggle action
      },
    ),
    AddRecipePage(),
    CategoriesPage(),
    ProfilePage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScaffoldWithNavBar(
          child: _pages[index],
          currentIndex: index,
          onNavItemTapped: _onNavItemTapped,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavBar(
      child: _pages[_currentIndex],
      currentIndex: _currentIndex,
      onNavItemTapped: _onNavItemTapped,
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onNavItemTapped;

  const ScaffoldWithNavBar({
    required this.child,
    required this.currentIndex,
    required this.onNavItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.redPinkMain,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: onNavItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
