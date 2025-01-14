import 'package:flutter/material.dart';
import 'package:recipe_app/models/mock_data.dart';
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
      home: const AppNavigator(),
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

  final List<String> _mainRoutes = [
    '/home',
    '/community',
    '/add_recipe',
    '/categories',
    '/profile',
  ];

  Widget _buildPage(String routeName) {
    switch (routeName) {
      case '/home':
        return HomePage();
      case '/community':
        return CommunityPage(
          currentUser: mockUsers[0],
          communityRecipes: mockRecipes,
          authors: mockUsers,
          onToggleFavorite: (recipe) {
            // Handle favorite toggle action
          },
        );
      case '/add_recipe':
        return AddRecipePage();
      case '/categories':
        return CategoriesPage();
      case '/profile':
        return ProfilePage();
      case '/onboarding':
        return OnboardingPage();
      case '/login_signup':
        return LoginSignupPage();
      case '/search':
        return SearchPage();
      case '/settings':
        return SettingsPage();
      case '/trending':
        return TrendingPage();
      default:
        throw Exception('Invalid route: $routeName');
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(index);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ScaffoldWithNavBar(
          child: _buildPage(_mainRoutes[index]),
          currentIndex: index,
          onNavItemTapped: _onNavItemTapped,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavBar(
      child: _buildPage(_mainRoutes[_currentIndex]),
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
