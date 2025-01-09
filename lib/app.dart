import 'package:flutter/material.dart';
import 'views/launch_page.dart';
import 'views/onboarding_page.dart';
import 'views/login_signup_page.dart';
import 'views/home_page.dart';
import 'views/categories_page.dart';
import 'views/profile_page.dart';
import 'views/search_page.dart';
import 'views/settings_page.dart';
import 'viewmodels/launch_viewmodel.dart';
import 'viewmodels/onboarding_viewmodel.dart';
import 'viewmodels/login_signup_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/categories_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';

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
        // Thêm các route khác nếu cần
      },
    );
  }
}
