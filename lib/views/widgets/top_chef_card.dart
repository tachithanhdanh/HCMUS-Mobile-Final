import 'package:flutter/material.dart';
import '../../models/user.dart';

class TopChefCard extends StatelessWidget {
  final User chef;

  TopChefCard({required this.chef});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: chef.profilePictureUrl.isNotEmpty
              ? NetworkImage(chef.profilePictureUrl)
              : AssetImage('assets/images/pochita.jpg') as ImageProvider,
          // Xử lý lỗi khi tải ảnh
          child: chef.profilePictureUrl.isEmpty
              ? Image.asset('assets/images/pochita.jpg', fit: BoxFit.cover)
              : null,
        ),
        title: Text(chef.username),
        subtitle: Text('${chef.createdRecipes.length} Recipes'),
      ),
    );
  }
}
