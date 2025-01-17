import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../constants/colors.dart';
import '../providers/user_provider.dart';

class FavoriteButton extends StatefulWidget {
  final String recipeId; // ID của công thức
  final VoidCallback? onRecipeUpdated; // Callback tùy chọn

  const FavoriteButton({
    Key? key,
    required this.recipeId,
    this.onRecipeUpdated,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final UserService _userService = UserService();
  bool isLoading = false;

  Future<void> _toggleFavorite() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Hiển thị trạng thái tải
    });

    try {
      // Gọi hàm toggle từ UserService
      final updatedUser = await _userService.toggleFavoriteRecipe(
        currentUser.id,
        widget.recipeId,
      );

      // Cập nhật trạng thái trong Provider
      // userProvider.setUser(updatedUser);
      userProvider.updateFavoriteRecipes(widget.recipeId);

      // Gọi callback nếu có
      if (widget.onRecipeUpdated != null) {
        widget.onRecipeUpdated!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Ẩn trạng thái tải
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    final isFavorite =
        currentUser?.favoriteRecipes.contains(widget.recipeId) ?? false;

    return GestureDetector(
      onTap: isLoading ? null : _toggleFavorite,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(6.0),
        child: isLoading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(AppColors.pinkSubColor),
                ),
              )
            : Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.pinkSubColor,
              ),
      ),
    );
  }
}
