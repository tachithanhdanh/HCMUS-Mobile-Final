from uuid import uuid4
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK (update with your credentials file path)
cred = credentials.Certificate("../firebase-adminsdk-key.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Function to update reviews with missing IDs
def update_reviews_with_ids():
    recipes_ref = db.collection("recipes")
    recipes = recipes_ref.stream()
    updates_count = 0

    for recipe in recipes:
        recipe_data = recipe.to_dict()
        reviews = recipe_data.get("reviews", [])

        for i, review in enumerate(reviews):
            # Check if 'id' is missing in the review
            if "id" not in review or not review["id"]:
                review["id"] = str(uuid4())  # Generate a unique ID

        # Update Firestore document
        recipe_data["reviews"] = reviews
        recipes_ref.document(recipe.id).set(recipe_data)
        updates_count += 1

    print(f"Updated {updates_count} recipes with missing review IDs.")

# Execute the script
if __name__ == "__main__":
    update_reviews_with_ids()
