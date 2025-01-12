// views/widgets/top_chef_card.dart
import 'package:flutter/material.dart';
import '../../models/user.dart'; // Sử dụng UserProfile

class TopChefCard extends StatelessWidget {
  final UserProfile chef; // Thay đổi kiểu thành UserProfile

  TopChefCard({required this.chef});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: chef.avatarUrl.isNotEmpty
              ? NetworkImage(chef.avatarUrl)
              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        title: Text(chef.name),
        subtitle: Text('${chef.favoriteRecipes.length} Favorite Recipes'),
      ),
    );
  }
}
