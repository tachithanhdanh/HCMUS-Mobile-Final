import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy công thức phổ biến
  Future<List<Recipe>> fetchTrendingRecipes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trending recipes: ${e.toString()}');
    }
  }

  // Lấy công thức theo danh mục
  Future<List<Recipe>> fetchRecipesByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .where('category', isEqualTo: categoryId)
          .get();

      return snapshot.docs
          .map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recipes by category: ${e.toString()}');
    }
  }

  // Lấy chi tiết công thức
  Future<Recipe> fetchRecipeDetails(String recipeId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('recipes').doc(recipeId).get();

      if (!doc.exists) {
        throw Exception('Recipe not found');
      }

      return Recipe.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch recipe details: ${e.toString()}');
    }
  }

  // Lưu công thức vào danh sách yêu thích của người dùng
  Future<void> saveRecipe(String userId, String recipeId) async {
    try {
      DocumentReference userDoc =
          _firestore.collection('users').doc(userId);

      await userDoc.update({
        'savedRecipes': FieldValue.arrayUnion([recipeId])
      });
    } catch (e) {
      throw Exception('Failed to save recipe: ${e.toString()}');
    }
  }
}
