import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'search_popup.dart'; // Đảm bảo file SearchPopup đã được import

class IconActions extends StatelessWidget {
  final List<dynamic> trendingRecipes;
  final List<dynamic> yourRecipes;

  const IconActions({
    Key? key,
    required this.trendingRecipes,
    required this.yourRecipes,
  }) : super(key: key);

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchPopup(
          recommendedRecipes: [
            ...trendingRecipes,
            ...yourRecipes,
          ],
        );
      },
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.of(context).pushNamed('/notifications');
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(
          context,
          icon: Icons.search,
          onTap: () => _showSearchDialog(context),
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          context,
          icon: Icons.notifications_none,
          onTap: () => _navigateToNotifications(context),
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          context,
          icon: Icons.account_circle,
          onTap: () => _navigateToProfile(context),
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pink,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.pinkSubColor),
        iconSize: 20,
      ),
    );
  }
}
