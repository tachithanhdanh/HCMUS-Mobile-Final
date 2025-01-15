import firebase_admin
from firebase_admin import auth, credentials, firestore

# Initialize the Firebase Admin SDK
cred = credentials.Certificate("../firebase-adminsdk-key.json")
firebase_admin.initialize_app(cred)

def add_user_to_firestore(uid, name, email):
    """Add user information to Firestore."""
    db = firestore.client()
    user_data = {
        "id": uid,
        "name": name,
        "email": email,
        "avatarUrl": "",
        "favoriteRecipes": []
    }
    db.collection("users").document(uid).set(user_data)
    print(f"User {name} added to Firestore.")

def create_users():
    """Create users in Firebase Authentication and save them to Firestore."""
    names = [
        "Alice", "Bob", "Charlie", "David", "Ella",
        "Fiona", "George", "Hannah", "Ian", "Julia",
        "Kevin", "Luna", "Mason", "Nina", "Oscar",
        "Paula", "Quinn", "Ryan", "Sophia", "Thomas"
    ]

    for i, name in enumerate(names, start=1):
        email = f"user{i}@gmail.com"
        password = "123456"
        try:
            # Create user in Firebase Authentication
            user = auth.create_user(
                email=email,
                password=password,
                display_name=name
            )
            print(f"Successfully created user: {user.uid} ({name})")

            # Add user information to Firestore
            add_user_to_firestore(user.uid, name, email)
        except Exception as e:
            print(f"Error creating user {name}: {e}")

if __name__ == "__main__":
    create_users()
