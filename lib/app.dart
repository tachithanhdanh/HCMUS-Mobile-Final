import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/community_page.dart';
import 'views/add_recipe_page.dart';
import 'views/categories_page.dart';
import 'views/profile_page.dart';
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
      home: MainScreen(initialRoute: '/home'),
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
        '/add_recipe': (context) => AddRecipePage(), // Route mới cho Add Recipe
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final String initialRoute;

  const MainScreen({super.key, required this.initialRoute});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _currentRoute;

  @override
  void initState() {
    super.initState();
    _currentRoute = widget.initialRoute; // Route mặc định
  }

  void _onNavItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _currentRoute = '/home';
          break;
        case 1:
          _currentRoute = '/community';
          break;
        case 2:
          _currentRoute = '/add_recipe';
          break;
        case 3:
          _currentRoute = '/categories';
          break;
        case 4:
          _currentRoute = '/profile';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Navigator(
          onGenerateRoute: (settings) {
            switch (_currentRoute) {
              case '/community':
                return MaterialPageRoute(builder: (_) => CommunityPage());
              case '/add_recipe':
                return MaterialPageRoute(builder: (_) => AddRecipePage());
              case '/categories':
                return MaterialPageRoute(builder: (_) => CategoriesPage());
              case '/profile':
                return MaterialPageRoute(builder: (_) => ProfilePage());
              default:
                return MaterialPageRoute(builder: (_) => HomePage());
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(),
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

  int _getSelectedIndex() {
    switch (_currentRoute) {
      case '/community':
        return 1;
      case '/add_recipe':
        return 2;
      case '/categories':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }
}
