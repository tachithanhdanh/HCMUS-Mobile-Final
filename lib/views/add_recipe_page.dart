import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import 'dart:convert';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/enums/category.dart';
import 'package:recipe_app/services/recipe_service.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  String? selectedCategory;
  String? selectedDifficulty;
  final List<Map<String, String>> _ingredients = [];

  final List<String> categories = [
    'Dessert', // Món tráng miệng
    'MainCourse', // Món chính
    'Appetizer', // Khai vị
    'Beverage', // Đồ uống
    'Snack', // Đồ ăn nhẹ
    'Other', // Danh mục khác
    'Breakfast',
    'Soup',
  ];

  final List<String> difficulties = [
    'Easy',
    'Medium',
    'Hard',
    'Very Hard',
  ];

  File? _selectedImage; // Lưu ảnh được chọn
  String imageUrl = ''; // Lưu URL ảnh

  // Hàm thêm nguyên liệu
  void _addIngredient() {
    setState(() {
      _ingredients.add({"quantity": "", "name": ""});
    });
  }

  // Hàm xóa nguyên liệu
  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  // Hàm chọn ảnh từ camera hoặc thư viện
  Future<void> _handleImagePicker(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Lưu file ảnh đã chọn
      });

      // Chuyển ảnh thành Base64
      final bytes = await _selectedImage!.readAsBytes(); // Đọc dữ liệu byte
      final base64Image = base64Encode(bytes); // Mã hóa Base64
      imageUrl = 'data:image/jpeg;base64,$base64Image';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Recipe',
          style: TextStyle(
              color: AppColors.redPinkMain, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.redPinkMain),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _handleImagePicker(ImageSource
                                    .gallery); // Chọn ảnh từ thư viện
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _handleImagePicker(
                                    ImageSource.camera); // Chụp ảnh từ camera
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.redPinkMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(
                                _selectedImage!), // Hiển thị ảnh đã chọn
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image,
                                  color: AppColors.redPinkMain,
                                  size: 50), // Icon hình ảnh
                              SizedBox(height: 8),
                              Text(
                                'Tap to add an image', // Nội dung mới
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Recipe title',
                  filled: true,
                  fillColor: AppColors.redPinkMain.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Recipe Description',
                  filled: true,
                  fillColor: AppColors.redPinkMain.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Time Recipe
              Text(
                'Time Recipe',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'e.g., 30min',
                  filled: true,
                  fillColor: AppColors.redPinkMain.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Category và Difficulty
              Row(
                children: [
                  // Dropdown cho Category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          items: categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.redPinkMain.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Khoảng cách giữa hai trường

                  // Dropdown cho Difficulty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Difficulty',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedDifficulty,
                          items: difficulties
                              .map(
                                (difficulty) => DropdownMenuItem(
                                  value: difficulty,
                                  child: Text(difficulty),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.redPinkMain.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedDifficulty = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ingredients
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  ..._ingredients.asMap().entries.map(
                    (entry) {
                      int index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Quantity',
                                  filled: true,
                                  fillColor:
                                      AppColors.redPinkMain.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                ),
                                onChanged: (value) {
                                  _ingredients[index]["quantity"] = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Ingredient',
                                  filled: true,
                                  fillColor:
                                      AppColors.redPinkMain.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                ),
                                onChanged: (value) {
                                  _ingredients[index]["name"] = value;
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeIngredient(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addIngredient,
                    icon: const Icon(Icons.add, color: AppColors.redPinkMain),
                    label: const Text(
                      'Add Ingredient',
                      style: TextStyle(color: AppColors.redPinkMain),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Instructions
              Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  hintText: 'Add cooking instructions...',
                  filled: true,
                  fillColor: AppColors.redPinkMain.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_titleController.text.isEmpty ||
                          _descriptionController.text.isEmpty ||
                          _timeController.text.isEmpty ||
                          _instructionsController.text.isEmpty ||
                          _ingredients.isEmpty ||
                          _selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Please fill out all fields and add an image.')),
                        );
                        return;
                      }

                      try {
                        // Tạo đối tượng Recipe mới
                        final recipe = Recipe(
                            id: '', // Firebase sẽ tự cấp phát ID
                            title: _titleController.text,
                            description: _descriptionController.text,
                            imageUrl: imageUrl,
                            cookTime: _timeController.text,
                            category: Category.values.firstWhere((e) =>
                                e.toString().split('.').last ==
                                (selectedCategory ??
                                    'Other')), // Mặc định là Other
                            authorId:
                                'user123', // Thay bằng ID người dùng hiện tại
                            reviews: [],
                            ingredients: _ingredients
                                .map((ingredient) =>
                                    '${ingredient['quantity']} ${ingredient['name']}')
                                .toList(), // Chuyển đổi nguyên liệu sang chuỗi
                            steps: _instructionsController.text.split(
                                '\n'), // Chia các bước nấu ăn bằng dấu xuống dòng
                            createdAt: DateTime.now(),
                            difficulty: Difficulty.values.firstWhere((e) =>
                                e.toString().split('.').last ==
                                (selectedDifficulty ?? 'Easy')));

                        // TODO: Upload ảnh lên Firestore Storage và lấy URL (bổ sung nếu cần)

                        // Gọi hàm tạo Recipe từ service
                        String newRecipeId =
                            await RecipeService().createRecipe(recipe);

                        // Navigate đến Recipe Detail Page với ID mới
                        Navigator.pushNamed(
                          context,
                          '/recipe_details',
                          arguments: newRecipeId,
                        );
                      } catch (e) {
                        // Hiển thị thông báo lỗi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Failed to create recipe: ${e.toString()}')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redPinkMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Publish'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Delete logic
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
