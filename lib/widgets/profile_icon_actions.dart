import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ProfileIconActions extends StatelessWidget {

  void _navigateToNotifications(BuildContext context) {
    Navigator.of(context).pushNamed('/notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        _buildIconButton(
          context,
          icon: Icons.notifications_none,
          onTap: () => _navigateToNotifications(context)
        )
      ]
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
      required IconData icon,
      required VoidCallback onTap
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pink
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.pinkSubColor),
        iconSize: 20
      )
    );
  }
}