// views/profile_page.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/models/user.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileViewModel _viewModel = ProfileViewModel();
  late Future<User> _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = _viewModel.getUserProfile('currentUserId');
  }

  void _editProfile() {
    // Điều hướng đến màn hình Edit Profile
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder<User>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Column(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePictureUrl)),
                Text(user.username, style: TextStyle(fontSize: 24)),
                Text(user.email),
                ElevatedButton(
                    onPressed: _editProfile, child: Text('Edit Profile')),
                ElevatedButton(
                    onPressed: _navigateToSettings, child: Text('Settings')),
                // Hiển thị công thức đã lưu và đã tạo
                Expanded(
                  child: ListView(
                    children: [
                      Text('Saved Recipes', style: TextStyle(fontSize: 20)),
                      // Danh sách công thức đã lưu
                      ...user.savedRecipes
                          .map((recipeId) => Text(recipeId))
                          .toList(),
                      Text('Created Recipes', style: TextStyle(fontSize: 20)),
                      // Danh sách công thức đã tạo
                      ...user.createdRecipes
                          .map((recipeId) => Text(recipeId))
                          .toList(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
