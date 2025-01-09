// views/onboarding_page.dart
import 'package:flutter/material.dart';
import '../viewmodels/onboarding_viewmodel.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  void _completeOnboarding() {
    // Giả sử người dùng đã nhập sở thích
    Map<String, dynamic> preferences = {
      'cookingLevel': 'Intermediate',
      'preferences': ['Vegan', 'Quick Meals'],
    };
    _viewModel.saveUserPreferences(preferences);
    Navigator.pushReplacementNamed(context, '/login_signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Recipe App')),
      body: Center(
        child: ElevatedButton(
          onPressed: _completeOnboarding,
          child: Text('Get Started'),
        ),
      ),
    );
  }
}
