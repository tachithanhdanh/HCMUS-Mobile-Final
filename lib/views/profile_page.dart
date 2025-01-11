import 'package:flutter/material.dart';
import 'package:recipe_app/models/user.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock data
    final user = User(
      username: 'John Doe',
      profilePictureUrl: 'https://via.placeholder.com/150',
      email: 'johndoe@example.com',
      savedRecipes: ['Recipe 1', 'Recipe 2'],
      createdRecipes: ['My Recipe 1', 'My Recipe 2'],
      id: '1',
    );

    void _navigateToSettings() {
      Navigator.pushNamed(context, '/settings');
    }

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(user.profilePictureUrl)),
          Text(user.username, style: TextStyle(fontSize: 24)),
          Text(user.email),
          ElevatedButton(
              onPressed: _navigateToSettings, child: Text('Settings')),
          Expanded(
            child: ListView(
              children: [
                Text('Saved Recipes', style: TextStyle(fontSize: 20)),
                ...user.savedRecipes.map((recipeId) => Text(recipeId)).toList(),
                Text('Created Recipes', style: TextStyle(fontSize: 20)),
                ...user.createdRecipes
                    .map((recipeId) => Text(recipeId))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
