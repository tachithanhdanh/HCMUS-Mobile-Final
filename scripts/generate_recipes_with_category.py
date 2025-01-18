import random
from datetime import datetime
from firebase_admin import credentials, firestore, initialize_app

# Khởi tạo Firebase Admin SDK
cred = credentials.Certificate("../firebase-adminsdk-key.json")  # Thay bằng đường dẫn file JSON
initialize_app(cred)

def create_recipes():
    db = firestore.client()

    # Lấy danh sách user từ Firestore
    users_ref = db.collection("users")
    users = [doc.id for doc in users_ref.stream()]

    if len(users) < 2:
        raise Exception("Not enough users in Firestore to assign recipes.")

    # Dữ liệu mẫu
    recipe_titles = [
        "Spaghetti Carbonara", "Chicken Alfredo", "Vegetable Stir Fry",
        "Beef Tacos", "Grilled Cheese Sandwich", "Tomato Soup",
        "Pan-Seared Salmon", "Caesar Salad", "Chocolate Cake",
        "Vanilla Ice Cream", "Garlic Bread", "Beef Stroganoff",
        "Egg Fried Rice", "Chicken Noodle Soup", "Tuna Casserole",
        "Pancakes", "French Toast", "Lemon Tart",
        "Shrimp Scampi", "Minestrone Soup"
    ]

    recipe_ingredients = [
        ["Pasta", "Eggs", "Cheese", "Bacon"],
        ["Chicken", "Cream", "Pasta", "Parmesan"],
        ["Broccoli", "Carrots", "Soy Sauce", "Garlic"],
        ["Ground Beef", "Taco Shells", "Lettuce", "Tomatoes"],
        ["Bread", "Cheese", "Butter"],
        ["Tomatoes", "Garlic", "Basil", "Olive Oil"],
        ["Salmon", "Lemon", "Butter", "Herbs"],
        ["Lettuce", "Croutons", "Caesar Dressing", "Parmesan"],
        ["Flour", "Sugar", "Cocoa Powder", "Eggs"],
        ["Milk", "Sugar", "Vanilla", "Cream"],
        ["Bread", "Garlic", "Butter"],
        ["Beef", "Mushrooms", "Onion", "Sour Cream"],
        ["Rice", "Eggs", "Carrots", "Soy Sauce"],
        ["Chicken", "Noodles", "Carrots", "Celery"],
        ["Tuna", "Pasta", "Cheese", "Milk"],
        ["Flour", "Milk", "Eggs", "Butter"],
        ["Bread", "Eggs", "Cinnamon", "Sugar"],
        ["Lemon", "Butter", "Eggs", "Sugar"],
        ["Shrimp", "Butter", "Garlic", "Pasta"],
        ["Beans", "Tomatoes", "Pasta", "Carrots"]
    ]

    recipe_steps = [
        ["Boil pasta", "Cook bacon", "Mix ingredients"],
        ["Cook chicken", "Prepare sauce", "Mix and serve"],
        ["Chop vegetables", "Stir-fry in wok", "Add sauce"],
        ["Cook beef", "Prepare taco toppings", "Assemble tacos"],
        ["Butter bread", "Add cheese", "Grill until golden"],
        ["Blend tomatoes", "Simmer with garlic", "Serve"],
        ["Season salmon", "Pan-sear", "Garnish with herbs"],
        ["Chop lettuce", "Add croutons", "Toss with dressing"],
        ["Mix dry ingredients", "Add eggs and milk", "Bake"],
        ["Heat milk", "Mix with vanilla", "Freeze"],
        ["Slice bread", "Spread garlic butter", "Bake"],
        ["Cook beef", "Add mushrooms and sauce", "Serve"],
        ["Cook rice", "Scramble eggs", "Mix everything"],
        ["Boil noodles", "Add chicken and vegetables", "Simmer"],
        ["Cook tuna", "Mix with pasta", "Bake"],
        ["Mix batter", "Cook on griddle", "Serve"],
        ["Dip bread in batter", "Fry in pan", "Serve"],
        ["Prepare tart crust", "Mix lemon filling", "Bake"],
        ["Cook shrimp", "Prepare garlic butter", "Mix with pasta"],
        ["Simmer beans and vegetables", "Add pasta", "Serve"]
    ]

    categories = ["Breakfast", "Lunch", "Dinner"]

    # Tạo danh sách công thức
    recipes = []
    assigned_users = random.sample(users, 2)  # 2 người dùng được chỉ định
    unassigned_users = list(set(users) - set(assigned_users))

    for user_id in users:
        num_recipes = 3 if user_id in assigned_users else random.randint(0, 1)

        for _ in range(num_recipes):
            idx = random.randint(0, len(recipe_titles) - 1)
            category = random.choice(categories)
            reviews = [
                {
                    "content": random.choice([
                        "Great recipe!", "Delicious!", "Could be better.", "Not my favorite.", "Easy to follow."
                    ]),
                    "createdAt": datetime.now(),
                    "id": f"review-{random.randint(1000, 9999)}",
                    "rating": random.randint(1, 5),
                    "userId": random.choice(users)
                }
                for _ in range(random.randint(1, 5))
            ]
            recipe = {
                "title": recipe_titles[idx],
                "description": f"A delicious recipe for {recipe_titles[idx].lower()}.",
                "ingredients": recipe_ingredients[idx],
                "steps": recipe_steps[idx],
                "imageUrl": "",
                "authorId": user_id,
                "reviews": reviews,
                "createdAt": datetime.now(),
                "category": category,
                "cookTime": f"{random.randint(10, 60)} mins",
                "difficulty": random.choice(["Easy", "Medium", "Hard"]),
            }
            recipes.append(recipe)

    # Lưu vào Firestore
    for recipe in recipes:
        db.collection("recipes").add(recipe)
        print(f"Added recipe: {recipe['title']} by user {recipe['authorId']}")

if __name__ == "__main__":
    create_recipes()
