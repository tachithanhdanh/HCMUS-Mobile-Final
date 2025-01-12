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
  late Future<UserProfile> _userProfile;

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
      body: FutureBuilder<UserProfile>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Column(
              children: [
                CircleAvatar(
                  backgroundImage: user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                  radius: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _editProfile,
                  child: Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: _navigateToSettings,
                  child: Text('Settings'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      Text('Favorite Recipes', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      // Danh sách công thức yêu thích
                      ...user.favoriteRecipes
                          .map((recipeId) => ListTile(
                                title: Text(recipeId),
                                leading:
                                    Icon(Icons.favorite, color: Colors.red),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading profile'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
