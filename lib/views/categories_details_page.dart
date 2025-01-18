import 'package:flutter/material.dart';
import 'package:recipe_app/constants/colors.dart';
import 'package:recipe_app/enums/category.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/services/user_service.dart';
import 'package:recipe_app/widgets/categories_recipe_card.dart';
import 'package:recipe_app/widgets/categories_icon_actions.dart';

class CategoriesDetailPage extends StatefulWidget {
  final Category selectedCategory;

  CategoriesDetailPage({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesDetailPage> {
  late String selectedFilter;
  List<Recipe> recipes = [];
  List<UserProfile> authors = [];
  List<Recipe> filteredRecipes = [];

  final List<Category> _categories = Category.values;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedCategory.name;
    _initData();
  }

  Future<void> _initData() async {
    try {
      final fetchedRecipes = await RecipeService().fetchAllRecipes();
      var userIds = fetchedRecipes.map((recipe) => recipe.authorId).toSet().toList();
      final fetchedAuthors = await UserService().fetchAuthorsByUserIds(userIds);

      setState(() {
        recipes = fetchedRecipes;
        authors = fetchedAuthors;
        filteredRecipes = List.from(fetchedRecipes);
        _applyFilter();
      });
    } catch (e) {
      return;
    }
  }

  void _applyFilter() {
    setState(() {
      filteredRecipes = recipes.where((recipe) => recipe.category.name == selectedFilter).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.redPinkMain),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    "Categories",
                    style: TextStyle(
                      color: AppColors.redPinkMain,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CategoriesIconActions(),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories
                      .map((category) => Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildFilterOption(category.name),
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: size.width > 600 ? 0.7 : 0.55,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    final author = authors.firstWhere(
                          (user) => user.id == recipe.authorId,
                      orElse: () => UserProfile(id: '', name: 'Unknown', email: '', avatarUrl: ''),
                    );
                    return CategoriesRecipeCard(
                      recipe: recipe,
                      author: author,
                      isFavorite: false,
                      onFavoriteToggle: () => {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    final isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.redPinkMain : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.redPinkMain),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.redPinkMain,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
