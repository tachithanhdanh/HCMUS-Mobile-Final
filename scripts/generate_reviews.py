import random
from firebase_admin import credentials, firestore, initialize_app

# Khởi tạo Firebase Admin SDK
cred = credentials.Certificate("../firebase-adminsdk-key.json")
initialize_app(cred)

def create_reviews():
    db = firestore.client()

    # Lấy danh sách recipe từ Firestore
    recipes_ref = db.collection("recipes")
    recipes = [doc for doc in recipes_ref.stream()]

    # Lấy danh sách user từ Firestore
    users_ref = db.collection("users")
    users = [doc for doc in users_ref.stream()]

    if not recipes or not users:
        raise Exception("No recipes or users available in Firestore.")

    # Nội dung review theo số sao
    review_texts = {
        1: [
            "The recipe was a disaster. Totally not worth it.",
            "Ingredients were off, and the taste was terrible.",
            "This was one of the worst recipes I’ve tried.",
            "Cooking instructions were confusing and incomplete.",
        ],
        2: [
            "Below average. Needs a lot of improvement.",
            "The taste was okay, but not great.",
            "Ingredients didn't blend well together.",
            "I wouldn't recommend this recipe to anyone.",
        ],
        3: [
            "Decent recipe, but it could be better.",
            "The taste was okay, but I might not make it again.",
            "Some instructions were unclear, but the result was fine.",
            "Good for a quick meal, but not memorable.",
        ],
        4: [
            "Pretty good recipe! The family enjoyed it.",
            "Easy to follow and tasty.",
            "The ingredients worked well together.",
            "A reliable recipe that I would try again.",
        ],
        5: [
            "Amazing recipe! Will definitely make it again.",
            "One of the best meals I’ve ever cooked.",
            "The instructions were clear, and the taste was incredible.",
            "Absolutely loved it. Highly recommended!",
        ],
    }

    # Tạo review
    for _ in range(50):  # Tổng cộng 50 reviews
        recipe = random.choice(recipes)
        recipe_id = recipe.id
        recipe_data = recipe.to_dict()
        author_id = recipe_data.get("authorId", "")

        # Đảm bảo tác giả không tự review bài của chính mình
        reviewers = [user for user in users if user.id != author_id]
        if not reviewers:
            continue  # Bỏ qua nếu không có người review hợp lệ

        reviewer = random.choice(reviewers)
        reviewer_id = reviewer.id

        # Random số sao với trọng số
        rating = random.choices([1, 2, 3, 4, 5], weights=[1, 2, 3, 3, 1])[0]
        content = random.choice(review_texts[rating])

        # Tạo review trong collection "reviews"
        review_data = {
            "userId": reviewer_id,
            "content": content,
            "rating": rating,
            "recipeId": recipe_id,
            "createdAt": firestore.SERVER_TIMESTAMP,
        }
        review_ref = db.collection("reviews").add(review_data)
        review_id = review_ref[1].id  # Lấy ID của review mới tạo

        # Cập nhật trường "reviews" của recipe với ID review
        recipe_reviews = recipe_data.get("reviews", [])
        recipe_reviews.append(review_id)
        db.collection("recipes").document(recipe_id).update({"reviews": recipe_reviews})

        print(f"Added review for recipe {recipe_data['title']} by user {reviewer_id} with rating {rating}")

if __name__ == "__main__":
    create_reviews()
