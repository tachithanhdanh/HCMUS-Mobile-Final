import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/community_page.dart';
import 'views/add_recipe_page.dart';
import 'views/categories_page.dart';
import 'views/profile_page.dart';
import 'views/onboarding_page.dart';
import 'views/login_signup_page.dart';
import 'views/search_page.dart';
import 'views/settings_page.dart';
import 'views/trending_page.dart';
import 'package:recipe_app/constants/colors.dart'; // Import file colors.dart

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
      home: const MainScreen(),
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/login_signup': (context) => LoginSignupPage(),
        '/home': (context) => HomePage(),
        '/categories': (context) => CategoriesPage(),
        '/profile': (context) => ProfilePage(),
        '/search': (context) => SearchPage(),
        '/settings': (context) => SettingsPage(),
        '/community': (context) => CommunityPage(),
        '/trending': (context) => TrendingPage(),
        '/add_recipe': (context) => AddRecipePage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách các trang được sử dụng trong `BottomNavigationBar`
  final List<Widget> _pages = [
    HomePage(),
    CommunityPage(),
    AddRecipePage(),
    CategoriesPage(),
    ProfilePage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Cập nhật chỉ số trang hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex], // Hiển thị trang hiện tại
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.redPinkMain,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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
