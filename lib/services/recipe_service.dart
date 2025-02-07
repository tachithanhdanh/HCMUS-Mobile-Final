import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách công thức (toàn bộ)
  Future<List<Recipe>> fetchAllRecipes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('recipes').get();

      return snapshot.docs
          .map((doc) =>
              Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all recipes: ${e.toString()}');
    }
  }

  // Lấy công thức phổ biến nhất (sắp xếp theo số lượt đánh giá)
  Future<List<Recipe>> fetchTrendingRecipes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .get(); // Lấy tất cả các công thức hoặc tùy chỉnh để hạn chế kết quả

      // Chuyển đổi dữ liệu và sắp xếp theo số lượng reviews
      List<Recipe> recipes = snapshot.docs
          .map((doc) =>
              Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Sắp xếp danh sách công thức theo số lượng đánh giá giảm dần
      recipes.sort((a, b) => b.reviews.length.compareTo(a.reviews.length));

      // Trả về tối đa 10 công thức
      return recipes.take(10).toList();
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
          .map((doc) =>
              Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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

      return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch recipe details: ${e.toString()}');
    }
  }

  // Lưu công thức vào danh sách yêu thích của người dùng
  Future<void> saveRecipe(String userId, String recipeId) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(userId);

      await userDoc.update({
        'savedRecipes': FieldValue.arrayUnion([recipeId])
      });
    } catch (e) {
      throw Exception('Failed to save recipe: ${e.toString()}');
    }
  }

  // Lấy danh sách công thức theo User ID
  Future<List<Recipe>> fetchRecipesByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .where('authorId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) =>
              Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recipes by user ID: ${e.toString()}');
    }
  }

  Future<Recipe?> fetchMostTrendingRecipe() async {
    try {
      // Lấy dữ liệu từ Firestore
      QuerySnapshot snapshot = await _firestore.collection('recipes').get();

      if (snapshot.docs.isEmpty) {
        return null; // Không có công thức nào
      }

      // Chuyển đổi dữ liệu từ Firestore sang danh sách Recipe
      List<Recipe> recipes = snapshot.docs
          .map((doc) {
            try {
              return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            } catch (e) {
              print('Error parsing recipe: $e');
              return null; // Bỏ qua công thức không hợp lệ
            }
          })
          .whereType<Recipe>()
          .toList(); // Loại bỏ các giá trị null

      if (recipes.isEmpty) {
        return null; // Không có công thức hợp lệ
      }

      // Tìm công thức có nhiều review nhất
      Recipe mostTrendingRecipe = recipes
          .reduce((a, b) => (a.reviews.length > b.reviews.length) ? a : b);

      return mostTrendingRecipe;
    } catch (e) {
      // Xử lý lỗi tổng quát
      throw Exception('Failed to fetch most trending recipe: ${e.toString()}');
    }
  }

  Future<String> createRecipe(Recipe recipe) async {
    try {
      // Thêm tài liệu mới và lấy DocumentReference
      DocumentReference docRef =
          await _firestore.collection('recipes').add(recipe.toMap());

      // Trả về ID của tài liệu mới
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create recipe: ${e.toString()}');
    }
  }

  Future<void> editRecipe(String recipeId, Recipe updatedRecipe) async {
    try {
      // Cập nhật thông tin công thức trên Firestore
      await _firestore
          .collection('recipes')
          .doc(recipeId)
          .update(updatedRecipe.toMap());
    } catch (e) {
      throw Exception('Failed to update recipe: ${e.toString()}');
    }
  }

  // Xóa công thức
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe: ${e.toString()}');
    }
  }

  Future<Recipe?> fetchRandomRecipe() async {
    try {
      // Lấy toàn bộ tài liệu từ collection
      QuerySnapshot querySnapshot =
          await _firestore.collection('recipes').get();
      if (querySnapshot.docs.isEmpty) return null;

      // Chọn ngẫu nhiên một tài liệu
      final randomIndex =
          (querySnapshot.docs.length * (DateTime.now().millisecond / 1000))
                  .floor() %
              querySnapshot.docs.length;

      final DocumentSnapshot randomDoc = querySnapshot.docs[randomIndex];
      return Recipe.fromMap(
          randomDoc.data() as Map<String, dynamic>, randomDoc.id);
    } catch (e) {
      print("Error fetching random recipe: $e");
      return null;
    }
  }
}
