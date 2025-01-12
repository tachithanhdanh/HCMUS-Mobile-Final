import 'package:recipe_app/enums/category.dart';

class CategoriesViewModel {
  // Lấy danh sách các danh mục
  Future<List<Category>> getCategories() async {
    // Logic lấy danh mục
    return Category.values; // Trả về tất cả danh mục từ enum
  }
}
