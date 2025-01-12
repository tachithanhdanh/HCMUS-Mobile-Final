import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập người dùng
  Future<UserProfile> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await getUserProfile(userCredential.user!.uid);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Đăng ký người dùng
  Future<UserProfile> signup(String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      UserProfile newUser = UserProfile(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        avatarUrl: '',
        favoriteRecipes: [],
      );

      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());

      return newUser;
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  // Lấy thông tin người dùng
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User profile not found');
      }

      return UserProfile.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(UserProfile user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());

      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.displayName != user.name) {
        await currentUser.updateDisplayName(user.name);
      }
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // Upload avatar và cập nhật profile sử dụng base64
  Future<UserProfile> uploadAvatar(File file, String userId) async {
    try {
      // Đọc file và chuyển đổi sang base64
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Tạo URL data với định dạng base64
      String imageUrl = 'data:image/jpeg;base64,$base64Image';

      // Cập nhật avatarUrl trong profile
      UserProfile currentUser = await getUserProfile(userId);
      UserProfile updatedUser = currentUser.copyWith(avatarUrl: imageUrl);
      await updateUserProfile(updatedUser);

      // Cập nhật photoURL trong Firebase Auth
      User? authUser = _auth.currentUser;
      if (authUser != null) {
        await authUser.updatePhotoURL(imageUrl);
      }

      return updatedUser;
    } catch (e) {
      throw Exception('Failed to upload avatar: ${e.toString()}');
    }
  }

  // Toggle yêu thích công thức
  Future<UserProfile> toggleFavoriteRecipe(
      String userId, String recipeId) async {
    try {
      UserProfile user = await getUserProfile(userId);
      List<String> updatedFavorites = List.from(user.favoriteRecipes);

      if (updatedFavorites.contains(recipeId)) {
        updatedFavorites.remove(recipeId);
      } else {
        updatedFavorites.add(recipeId);
      }

      UserProfile updatedUser =
          user.copyWith(favoriteRecipes: updatedFavorites);
      await updateUserProfile(updatedUser);
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to toggle favorite recipe: ${e.toString()}');
    }
  }

  // Đăng xuất người dùng
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // Kiểm tra trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
