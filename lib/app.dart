import 'package:flutter/material.dart';
import 'views/launch_page.dart';
import 'views/onboarding_page.dart';
import 'views/login_signup_page.dart';
import 'views/home_page.dart';
import 'views/categories_page.dart';
import 'views/profile_page.dart';
import 'views/search_page.dart';
import 'views/settings_page.dart';
import 'views/community_page.dart';
import 'views/trending_page.dart';
import 'views/recipe_page.dart';
import 'views/review1_page.dart';
import 'views/review2_page.dart';
import 'views/add_recipe1_page.dart';
import 'views/add_recipe2_page.dart';
import 'views/edit_recipe_page.dart';
import 'views/profile_your_recipe_page.dart';
import 'views/profile_favorites_page.dart';

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
      home: LaunchPage(),
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
      },
    );
  }
}
