import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/services/user_service.dart';

class RecipeUserProfileRow extends StatefulWidget {
  final String authorId; // ID của author (lấy từ recipe.authorId)
  final bool isAuthorCurrentUser; // true nếu author là user đang đăng nhập
  final VoidCallback onEditRecipe; // Callback khi nhấn Edit Recipe
  final VoidCallback onAddReview; // Callback khi nhấn Add Review

  const RecipeUserProfileRow({
    Key? key,
    required this.authorId,
    required this.isAuthorCurrentUser,
    required this.onEditRecipe,
    required this.onAddReview,
  }) : super(key: key);

  @override
  State<RecipeUserProfileRow> createState() => _UserProfileRowState();
}

class _UserProfileRowState extends State<RecipeUserProfileRow> {
  final UserService _userService = UserService();
  late Future<UserProfile?> _authorProfile;

  @override
  void initState() {
    super.initState();
    // Fetch thông tin user từ authorId
    _authorProfile = _userService.fetchUserById(widget.authorId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _authorProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Failed to load user'));
        }

        final userProfile = snapshot.data;
        if (userProfile == null) {
          return Center(child: Text('User not found'));
        }

        // Tên người dùng, email và avatar
        final avatarUrl = userProfile.avatarUrl.isNotEmpty
            ? userProfile.avatarUrl
            : 'assets/images/gojo_satoru.png';
        final username = '@${userProfile.email.split('@').first}';
        final name = userProfile.name;

        return Column(
          children: [
            // Hàng nút "Edit Recipe" hoặc "Add Review"
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.isAuthorCurrentUser
                    ? widget.onEditRecipe
                    : widget.onAddReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redPinkMain,
                  foregroundColor: AppColors.whiteBeige,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  widget.isAuthorCurrentUser ? 'Edit Recipe' : 'Add Review',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Dòng thông tin người dùng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar và thông tin người dùng
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl) as ImageProvider
                          : AssetImage('assets/images/gojo_satoru.png'),
                    ),
                    const SizedBox(width: 12),
                    // Username và name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Nút "Edit Profile" nếu là tác giả
                if (widget.isAuthorCurrentUser)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
