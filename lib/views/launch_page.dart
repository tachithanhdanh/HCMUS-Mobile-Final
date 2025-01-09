// views/launch_page.dart
import 'package:flutter/material.dart';
import '../viewmodels/launch_viewmodel.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final LaunchViewModel _viewModel = LaunchViewModel();

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    bool loggedIn = await _viewModel.isLoggedIn();
    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Căn giữa theo chiều dọc
          children: [
            Image.asset(
              'assets/logo.jpg', // Logo ứng dụng
              width: 150, // Đặt kích thước logo nếu cần
              height: 150,
            ),
            SizedBox(height: 20), // Khoảng cách giữa logo và chữ
            Text(
              'Launch Page', // Nội dung văn bản
              style: TextStyle(
                fontSize: 24, // Kích thước chữ
                fontWeight: FontWeight.bold, // Đậm chữ
                color: Colors.black, // Màu chữ
              ),
            ),
          ],
        ),
      ),
    );
  }
}
