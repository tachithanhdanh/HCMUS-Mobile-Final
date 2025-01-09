// views/widgets/top_chef_card.dart
import 'package:flutter/material.dart';
import '../../models/user.dart';

class TopChefCard extends StatelessWidget {
  final User chef;

  TopChefCard({required this.chef});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            CircleAvatar(backgroundImage: NetworkImage(chef.profilePictureUrl)),
        title: Text(chef.username),
        subtitle: Text('${chef.createdRecipes.length} Recipes'),
      ),
    );
  }
}
