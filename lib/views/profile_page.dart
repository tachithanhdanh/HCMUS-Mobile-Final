import 'package:flutter/material.dart';
import 'package:recipe_app/models/user.dart';
import '../viewmodels/profile_viewmodel.dart';

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
    // Giả định userId được lấy từ đâu đó, tạm thời hardcode
    _userProfile = _viewModel.getUserProfile('currentUserId');
  }

  void _editProfile() {
    // Điều hướng đến màn hình Edit Profile
    Navigator.pushNamed(context, '/edit_profile');
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading profile: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: user.avatarUrl.isNotEmpty
                          ? NetworkImage(user.avatarUrl)
                          : AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      user.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _editProfile,
                        child: Text('Edit Profile'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _navigateToSettings,
                        child: Text('Settings'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          'Favorite Recipes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (user.favoriteRecipes.isEmpty)
                          Center(
                            child: Text(
                              'No favorite recipes found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          ...user.favoriteRecipes.map((recipeId) {
                            return ListTile(
                              title: Text(recipeId),
                              leading: Icon(Icons.favorite, color: Colors.red),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
