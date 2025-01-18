import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/models/mock_data.dart';
import 'package:recipe_app/views/notifications_page.dart';
import 'package:recipe_app/services/user_service.dart';
import 'package:recipe_app/views/recipe_details_page.dart';
import 'package:recipe_app/views/signup_page.dart';
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
import 'views/recipe_reviews.dart';
import 'constants/colors.dart'; // Import AppColors
import 'widgets/bottom_nav_bar.dart'; // Import CustomBottomNavBar

class MyApp extends StatelessWidget {
  final UserService _userService = UserService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: _userService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Nếu đã đăng nhập
          if (snapshot.hasData) {
            return PageWithNavBar(child: HomePage());
          }

          // Nếu chưa đăng nhập
          return LoginSignupPage();
        },
      ),
      routes: {
        '/home': (context) => PageWithNavBar(
              child: HomePage(),
            ),
        '/community': (context) => PageWithNavBar(
              child: CommunityPage(),
            ),
        '/add_recipe': (context) => PageWithNavBar(child: AddRecipePage()),
        '/categories': (context) => PageWithNavBar(child: CategoriesPage()),
        '/profile': (context) => PageWithNavBar(child: ProfilePage()),
        '/onboarding': (context) => OnboardingPage(),
        '/login_signup': (context) => LoginSignupPage(),
        '/signup': (context) => SignupPage(),
        '/search': (context) => PageWithNavBar(child: SearchPage()),
        '/settings': (context) => PageWithNavBar(child: SettingsPage()),
        '/trending': (context) => PageWithNavBar(
              child: TrendingPage(),
            ),
        '/notifications': (context) =>
            PageWithNavBar(child: NotificationsPage()),
        '/recipe_details': (context) =>
            PageWithNavBar(child: RecipeDetailsPage()),
        '/recipe_reviews': (context) =>
            PageWithNavBar(child: RecipeReviewsPage()),
      },
    );
  }
}

class PageWithNavBar extends StatelessWidget {
  final Widget child;

  const PageWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
