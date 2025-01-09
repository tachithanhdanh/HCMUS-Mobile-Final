// views/login_signup_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/viewmodels/login_signup_viewmodel.dart';
import '../viewmodels/login_signup_viewmodel.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final LoginSignupViewModel _viewModel = LoginSignupViewModel();

  void _login() async {
    bool success = await _viewModel.login('email', 'password');
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _signup() async {
    bool success = await _viewModel.signup('username', 'email', 'password');
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login or Sign Up')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _login, child: Text('Login')),
            ElevatedButton(onPressed: _signup, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
