import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập người dùng
  Future<User> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found in Firestore');
      }

      return User.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Đăng ký người dùng
  Future<User> signup(String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      User newUser = User(
        id: userId,
        username: username,
        email: email,
        profilePictureUrl: '',
        savedRecipes: [],
        createdRecipes: [],
      );

      await _firestore.collection('users').doc(userId).set(newUser.toMap());

      return newUser;
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  // Lấy thông tin người dùng
  Future<User> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      return User.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
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
}
