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
  UserProfile(
    id: 'user3',
    name: 'Sophia Bennett',
    email: 'sophia.bennett@example.com',
    avatarUrl: '',
    favoriteRecipes: ['recipe3', 'recipe5'],
  ),
  UserProfile(
    id: 'user4',
    name: 'Ethan Carter',
    email: 'ethan.carter@example.com',
    avatarUrl: '',
    favoriteRecipes: ['recipe2', 'recipe4'],
  ),
  UserProfile(
    id: 'user5',
    name: 'Mia Thompson',
    email: 'mia.thompson@example.com',
    avatarUrl: '',
    favoriteRecipes: ['recipe6'],
  ),
  UserProfile(
    id: 'user6',
    name: 'Liam Johnson',
    email: 'liam.johnson@example.com',
    avatarUrl: '',
    favoriteRecipes: ['recipe1', 'recipe7', 'recipe8'],
  ),
  UserProfile(
    id: 'user7',
    name: 'Emma Davis',
    email: 'emma.davis@example.com',
    avatarUrl: '',
    favoriteRecipes: ['recipe9', 'recipe10'],
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
  Review(
    id: 'review3',
    userId: 'user3',
    content: 'Pretty good, but it could use more seasoning.',
    rating: 3,
    createdAt: DateTime.now().subtract(Duration(days: 5)),
  ),
  Review(
    id: 'review4',
    userId: 'user4',
    content: 'Absolutely delicious. Will make again!',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 7)),
  ),
  Review(
    id: 'review5',
    userId: 'user5',
    content: 'Not my favorite, but it’s okay.',
    rating: 3,
    createdAt: DateTime.now().subtract(Duration(days: 10)),
  ),
  Review(
    id: 'review6',
    userId: 'user6',
    content: 'Perfect for a family dinner. Everyone loved it.',
    rating: 4,
    createdAt: DateTime.now().subtract(Duration(days: 12)),
  ),
  Review(
    id: 'review7',
    userId: 'user7',
    content: 'This recipe was way too salty for my taste.',
    rating: 2,
    createdAt: DateTime.now().subtract(Duration(days: 15)),
  ),
  Review(
    id: 'review8',
    userId: 'user3',
    content: 'Simple and easy to follow. Great for beginners.',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 18)),
  ),
  Review(
    id: 'review9',
    userId: 'user4',
    content: 'A classic recipe done right!',
    rating: 4,
    createdAt: DateTime.now().subtract(Duration(days: 20)),
  ),
  Review(
    id: 'review10',
    userId: 'user5',
    content: 'I added extra spices, and it turned out amazing.',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 22)),
  ),
  Review(
    id: 'review11',
    userId: 'user6',
    content: 'Could be better with more detailed instructions.',
    rating: 3,
    createdAt: DateTime.now().subtract(Duration(days: 25)),
  ),
  Review(
    id: 'review12',
    userId: 'user7',
    content: 'Overcooked even though I followed the recipe exactly.',
    rating: 2,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
  ),
  Review(
    id: 'review13',
    userId: 'user3',
    content: 'Really tasty and easy to make!',
    rating: 4,
    createdAt: DateTime.now().subtract(Duration(days: 35)),
  ),
  Review(
    id: 'review14',
    userId: 'user4',
    content: 'A bit bland for my taste. Needed more spices.',
    rating: 3,
    createdAt: DateTime.now().subtract(Duration(days: 40)),
  ),
  Review(
    id: 'review15',
    userId: 'user5',
    content: 'The best recipe I’ve tried this month!',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 45)),
  ),
  Review(
    id: 'review16',
    userId: 'user6',
    content: 'It was okay, but not something I’d make again.',
    rating: 3,
    createdAt: DateTime.now().subtract(Duration(days: 50)),
  ),
  Review(
    id: 'review17',
    userId: 'user7',
    content: 'Very detailed instructions. Perfect for beginners.',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 55)),
  ),
  Review(
    id: 'review18',
    userId: 'user3',
    content: 'The texture was off, but the flavor was good.',
    rating: 3,
    createdAt: DateTime.now().subtract(Duration(days: 60)),
  ),
  Review(
    id: 'review19',
    userId: 'user4',
    content: 'An excellent recipe. My family loved it.',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 65)),
  ),
  Review(
    id: 'review20',
    userId: 'user5',
    content: 'This is now one of my go-to recipes.',
    rating: 5,
    createdAt: DateTime.now().subtract(Duration(days: 70)),
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
    reviews: [mockReviews[0], mockReviews[4], mockReviews[8]],
    createdAt: DateTime.now().subtract(Duration(days: 730)),
    category: Category.MainCourse,
    cookTime: '45 min',
    difficulty: Difficulty.Medium,
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
    reviews: [mockReviews[1], mockReviews[5], mockReviews[9]],
    createdAt: DateTime.now().subtract(Duration(days: 11)),
    category: Category.Dessert,
    cookTime: '38 min',
    difficulty: Difficulty.Hard,
  ),
  Recipe(
    id: 'recipe3',
    title: 'Beef Stroganoff',
    description: 'A creamy and delicious beef stroganoff.',
    ingredients: ['Beef', 'Mushrooms', 'Onion', 'Cream', 'Pasta'],
    steps: ['Cook beef', 'Sauté mushrooms', 'Prepare cream sauce', 'Serve'],
    imageUrl: '',
    authorId: 'user1',
    reviews: [mockReviews[2], mockReviews[6], mockReviews[10]],
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    category: Category.MainCourse,
    cookTime: '50 min',
    difficulty: Difficulty.Medium,
  ),
  Recipe(
    id: 'recipe4',
    title: 'Classic Pancakes',
    description: 'Easy-to-make fluffy pancakes.',
    ingredients: ['Flour', 'Milk', 'Eggs', 'Butter', 'Sugar'],
    steps: ['Mix ingredients', 'Cook on griddle', 'Serve with syrup'],
    imageUrl: '',
    authorId: 'user4',
    reviews: [mockReviews[3], mockReviews[7], mockReviews[11]],
    createdAt: DateTime.now().subtract(Duration(days: 90)),
    category: Category.Breakfast,
    cookTime: '20 min',
    difficulty: Difficulty.Easy,
  ),
  Recipe(
    id: 'recipe5',
    title: 'Vegetarian Lasagna',
    description: 'A healthy and hearty vegetarian lasagna.',
    ingredients: ['Lasagna Noodles', 'Tomatoes', 'Zucchini', 'Cheese'],
    steps: ['Layer ingredients', 'Bake in oven', 'Serve hot'],
    imageUrl: '',
    authorId: 'user5',
    reviews: [mockReviews[4], mockReviews[12], mockReviews[16]],
    createdAt: DateTime.now().subtract(Duration(days: 150)),
    category: Category.MainCourse,
    cookTime: '1 hr',
    difficulty: Difficulty.Medium,
  ),
  Recipe(
    id: 'recipe6',
    title: 'Chocolate Cake',
    description: 'A rich and moist chocolate cake recipe.',
    ingredients: ['Flour', 'Cocoa Powder', 'Eggs', 'Milk', 'Sugar'],
    steps: ['Mix ingredients', 'Bake in oven', 'Cool and serve'],
    imageUrl: '',
    authorId: 'user6',
    reviews: [mockReviews[13], mockReviews[17], mockReviews[19]],
    createdAt: DateTime.now().subtract(Duration(days: 200)),
    category: Category.Dessert,
    cookTime: '1 hr 30 min',
    difficulty: Difficulty.Hard,
  ),
  Recipe(
    id: 'recipe7',
    title: 'Caesar Salad',
    description: 'A classic Caesar salad with homemade dressing.',
    ingredients: ['Lettuce', 'Croutons', 'Parmesan', 'Caesar Dressing'],
    steps: ['Chop lettuce', 'Prepare dressing', 'Toss and serve'],
    imageUrl: '',
    authorId: 'user7',
    reviews: [mockReviews[14], mockReviews[18]],
    createdAt: DateTime.now().subtract(Duration(days: 250)),
    category: Category.Appetizer,
    cookTime: '15 min',
    difficulty: Difficulty.Easy,
  ),
  Recipe(
    id: 'recipe8',
    title: 'Spaghetti Carbonara',
    description: 'An authentic Italian spaghetti carbonara.',
    ingredients: ['Spaghetti', 'Eggs', 'Pancetta', 'Parmesan', 'Black Pepper'],
    steps: ['Cook spaghetti', 'Prepare sauce', 'Combine and serve'],
    imageUrl: '',
    authorId: 'user1',
    reviews: [mockReviews[5], mockReviews[15]],
    createdAt: DateTime.now().subtract(Duration(days: 300)),
    category: Category.MainCourse,
    cookTime: '30 min',
    difficulty: Difficulty.Medium,
  ),
  Recipe(
      id: 'recipe9',
      title: 'Banana Bread',
      description: 'A moist and flavorful banana bread.',
      ingredients: ['Bananas', 'Flour', 'Sugar', 'Eggs', 'Butter'],
      steps: ['Mix ingredients', 'Bake in oven', 'Cool and serve'],
      imageUrl: '',
      authorId: 'user4',
      reviews: [mockReviews[6], mockReviews[16]],
      createdAt: DateTime.now().subtract(Duration(days: 350)),
      category: Category.Breakfast,
      cookTime: '1 hr',
      difficulty: Difficulty.VeryHard),
  Recipe(
    id: 'recipe10',
    title: 'Tomato Soup',
    description: 'A simple and comforting tomato soup.',
    ingredients: ['Tomatoes', 'Onion', 'Garlic', 'Cream', 'Basil'],
    steps: ['Cook tomatoes', 'Blend ingredients', 'Simmer and serve'],
    imageUrl: '',
    authorId: 'user5',
    reviews: [mockReviews[7], mockReviews[11], mockReviews[17]],
    createdAt: DateTime.now().subtract(Duration(days: 400)),
    category: Category.Soup,
    cookTime: '40 min',
    difficulty: Difficulty.Medium,
  ),
];
