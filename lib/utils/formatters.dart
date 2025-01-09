// utils/formatters.dart
class Formatters {
  // Định dạng ngày tháng
  static String formatDate(DateTime date) {
    // Logic định dạng ngày tháng
    return '${date.day}/${date.month}/${date.year}';
  }

  // Định dạng số lượt thích
  static String formatLikes(int likes) {
    return '$likes likes';
  }
}
