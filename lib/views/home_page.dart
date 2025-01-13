import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/enums/category.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/review.dart';
import 'package:recipe_app/models/user.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock data for the current user
  final UserProfile currentUser = UserProfile(
    id: '3',
    name: 'Dianne',
    email: 'dianne@example.com',
    avatarUrl: '', // Có thể thêm ảnh profile nếu cần
    favoriteRecipes: ['1', '2', '3'],
  );

  // Mock data for Recipes
  final trendingRecipes = [
    Recipe(
      id: '1',
      title: 'Pasta Carbonara',
      description: 'A simple pasta dish',
      ingredients: ['Pasta', 'Eggs', 'Cheese', 'Bacon'],
      steps: ['Boil pasta', 'Cook bacon', 'Mix ingredients'],
      imageUrl: '',
      authorId: '1',
      reviews: [
        Review(
            id: 'r1',
            userId: 'u1',
            content: 'Great recipe',
            rating: 5,
            createdAt: DateTime.now()),
        Review(
            id: 'r2',
            userId: 'u2',
            content: 'Good taste',
            rating: 4,
            createdAt: DateTime.now()),
        Review(
            id: 'r3',
            userId: 'u3',
            content: 'Could be better',
            rating: 4,
            createdAt: DateTime.now()),
      ],
      createdAt: DateTime.now(),
      category: Category.MainCourse,
      cookTime: '30 mins',
    )
  ];

  // Mock data for Your Recipes
  final yourRecipes = [
    Recipe(
      id: '2',
      title: 'Margherita Pizza',
      description: 'Classic Italian pizza with fresh ingredients.',
      ingredients: ['Flour', 'Tomatoes', 'Cheese', 'Basil'],
      steps: ['Prepare dough', 'Add toppings', 'Bake in oven'],
      imageUrl: '',
      authorId: '1',
      reviews: [
        Review(
            id: 'r4',
            userId: 'u4',
            content: 'Loved it!',
            rating: 5,
            createdAt: DateTime.now()),
        Review(
            id: 'r5',
            userId: 'u5',
            content: 'Good but needs more cheese.',
            rating: 4,
            createdAt: DateTime.now()),
      ],
      createdAt: DateTime.now(),
      category: Category.MainCourse,
      cookTime: '45 mins',
    ),
    Recipe(
      id: '3',
      title: 'Caesar Salad',
      description: 'Healthy salad with a creamy dressing.',
      ingredients: ['Lettuce', 'Croutons', 'Parmesan', 'Caesar dressing'],
      steps: ['Chop lettuce', 'Prepare dressing', 'Mix and serve'],
      imageUrl: '',
      authorId: '1',
      reviews: [
        Review(
            id: 'r6',
            userId: 'u6',
            content: 'Very refreshing!',
            rating: 5,
            createdAt: DateTime.now()),
        Review(
            id: 'r7',
            userId: 'u7',
            content: 'Too much dressing for me.',
            rating: 3,
            createdAt: DateTime.now()),
      ],
      createdAt: DateTime.now(),
      category: Category.Appetizer,
      cookTime: '15 mins',
    ),
    Recipe(
      id: '4',
      title: 'Beef Stroganoff',
      description: 'Creamy Russian dish with tender beef.',
      ingredients: ['Beef', 'Mushrooms', 'Cream', 'Onion'],
      steps: ['Cook beef', 'Prepare sauce', 'Mix together and serve'],
      imageUrl: '',
      authorId: '1',
      reviews: [
        Review(
            id: 'r8',
            userId: 'u8',
            content: 'Fantastic dish!',
            rating: 5,
            createdAt: DateTime.now()),
        Review(
            id: 'r9',
            userId: 'u9',
            content: 'Could use more seasoning.',
            rating: 4,
            createdAt: DateTime.now()),
      ],
      createdAt: DateTime.now(),
      category: Category.MainCourse,
      cookTime: '40 mins',
    ),
  ];

  // Toggle favorite status
  void _toggleFavorite(String recipeId) {
    setState(() {
      if (currentUser.favoriteRecipes.contains(recipeId)) {
        currentUser.favoriteRecipes.remove(recipeId);
      } else {
        currentUser.favoriteRecipes.add(recipeId);
      }
    });
  }

  // Get favorite recipes
  List<Recipe> get favoriteRecipes {
    // Hợp nhất cả trendingRecipes và yourRecipes
    final allRecipes = [...trendingRecipes, ...yourRecipes];

    // Lọc các recipes có id nằm trong favoriteRecipes của user
    return allRecipes
        .where((recipe) => currentUser.favoriteRecipes.contains(recipe.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bao bọc tất cả trừ "Your Recipes" trong Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header (Instead of AppBar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dòng đầu tiên: Hi, user name và icon bên phải
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text: Hi, user name
                            Text(
                              "Hi! ${currentUser.name}",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Icon Actions
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.notifications_none,
                                      color: Colors.redAccent),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.account_circle,
                                      color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Dòng thứ hai: What are you cooking today
                        Text(
                          "What are you cooking today",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Trending Recipe Section
                  Text(
                    "Trending Recipe",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redPinkMain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTrendingRecipes(trendingRecipes),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Your Recipes Section
            Container(
              width: double.infinity, // Chiếm toàn bộ chiều ngang
              decoration: BoxDecoration(
                color: AppColors.redPinkMain, // Màu nền
                borderRadius: BorderRadius.circular(12), // Bo viền
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    "Your Recipes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách Recipes
                  _buildYourRecipes(context, yourRecipes),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity, // Chiếm toàn bộ chiều ngang
              decoration: BoxDecoration(
                color: AppColors.redPinkMain, // Màu nền
                borderRadius: BorderRadius.circular(12), // Bo viền
              ),
              padding: const EdgeInsets.all(16.0), // Khoảng cách bên trong
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    "Favorites",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Chữ màu trắng
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách Recipes
                  _buildFavorites(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingRecipes(List<Recipe> recipes) {
    return Column(
      children: recipes.map((recipe) {
        return RecipeCard(
          recipe: recipe,
          isFavorite: currentUser.favoriteRecipes.contains(recipe.id),
          onFavoriteToggle: () => _toggleFavorite(recipe.id),
        );
      }).toList(),
    );
  }

  Widget _buildYourRecipes(BuildContext context, List<Recipe> recipes) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recipes.map((recipe) {
          return Container(
            width: MediaQuery.of(context).size.width / 2 -
                24, // Chiều rộng vừa đủ để hiển thị 2 thẻ
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: RecipeCard(
              recipe: recipe,
              isFavorite: currentUser.favoriteRecipes.contains(recipe.id),
              onFavoriteToggle: () => _toggleFavorite(recipe.id),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFavorites() {
    final recipes = favoriteRecipes;
    if (recipes.isEmpty) {
      return Text("No favorites yet.");
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recipes.map((recipe) {
          return Container(
            width: MediaQuery.of(context).size.width / 2 -
                24, // Chiều rộng vừa đủ để hiển thị 2 thẻ
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: RecipeCard(
              recipe: recipe,
              isFavorite: currentUser.favoriteRecipes.contains(recipe.id),
              onFavoriteToggle: () => _toggleFavorite(recipe.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
