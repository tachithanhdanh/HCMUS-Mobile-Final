// services/category_service.dart
import '../models/category.dart';

class CategoryService {
  // Lấy danh sách các danh mục
  Future<List<Category>> fetchCategories() async {
    // Gọi API hoặc truy xuất dữ liệu
    return [
      Category(id: '1', name: 'Breakfast', iconUrl: 'url1'),
      Category(id: '2', name: 'Lunch', iconUrl: 'url2'),
      // Thêm các danh mục khác
    ]; // Placeholder
  }
}
