import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_profile.dart';
import 'package:recipe_app/models/review.dart';
import 'package:recipe_app/enums/category.dart';

List<UserProfile> mockUsers = [
  UserProfile(
    id: 'user1',
    name: 'Josh Ryan',
    email: 'josh.ryan@example.com',
    avatarUrl: '',
    favoriteRecipes: ['recipe1'],
  ),
  UserProfile(
    id: 'user2',
    name: 'Dakota Mullen',
    email: 'dakota.mullen@example.com',
    avatarUrl: '',
    favoriteRecipes: [],
  ),
];

List<Review> mockReviews = [
  Review(
    id: 'review1',
    userId: 'user1',
    content: 'This recipe is amazing!',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 2)),
  ),
  Review(
    id: 'review2',
    userId: 'user2',
    content: 'I loved it!',
    rating: 4,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
  ),
];

List<Recipe> mockRecipes = [
  Recipe(
    id: 'recipe1',
    title: 'Chicken Curry',
    description:
        'This recipe requires basic ingredients and minimal prep time.',
    ingredients: ['Chicken', 'Curry Powder', 'Onion', 'Garlic', 'Tomato'],
    steps: ['Cut chicken', 'Cook onion', 'Add spices', 'Simmer until done'],
    imageUrl: '',
    authorId: 'user1',
    reviews: mockReviews,
    createdAt: DateTime.now().subtract(Duration(days: 730)),
    category: Category.MainCourse,
    cookTime: '45 min',
  ),
  Recipe(
    id: 'recipe2',
    title: 'Macarons',
    description:
        'This recipe will guide you through the art of making perfect macarons.',
    ingredients: ['Almond Flour', 'Sugar', 'Egg Whites', 'Food Coloring'],
    steps: ['Mix ingredients', 'Pipe batter', 'Bake', 'Assemble with filling'],
    imageUrl: '',
    authorId: 'user2',
    reviews: [],
    createdAt: DateTime.now().subtract(Duration(days: 11)),
    category: Category.Dessert,
    cookTime: '38 min',
  ),
];
