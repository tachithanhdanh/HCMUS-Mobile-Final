import os

# Define the folder structure
structure = {
    "lib": {
        "models": {
            "recipe.dart": "",
            "user.dart": "",
            "category.dart": "",
        },
        "viewmodels": {
            "launch_viewmodel.dart": "",
            "onboarding_viewmodel.dart": "",
            "home_viewmodel.dart": "",
            "categories_viewmodel.dart": "",
            "trending_viewmodel.dart": "",
            "profile_viewmodel.dart": "",
            "recipe_details_viewmodel.dart": "",
            "search_viewmodel.dart": "",
        },
        "views": {
            "launch_page.dart": "",
            "onboarding_page.dart": "",
            "login_signup_page.dart": "",
            "home_page.dart": "",
            "categories_page.dart": "",
            "trending_page.dart": "",
            "recipe_details_page.dart": "",
            "profile_page.dart": "",
            "search_page.dart": "",
            "settings_page.dart": "",
            "widgets": {
                "recipe_card.dart": "",
                "category_card.dart": "",
                "top_chef_card.dart": "",
                "floating_menu.dart": "",
                "bottom_nav_bar.dart": "",
                "custom_button.dart": "",
            },
        },
        "services": {
            "recipe_service.dart": "",
            "user_service.dart": "",
            "category_service.dart": "",
        },
        "utils": {
            "validators.dart": "",
            "formatters.dart": "",
        },
        "main.dart": "",
        "app.dart": "",
    }
}

# Function to create folders and files
def create_structure(base_path, structure):
    for name, content in structure.items():
        path = os.path.join(base_path, name)
        if isinstance(content, dict):  # It's a folder
            os.makedirs(path, exist_ok=True)
            create_structure(path, content)
        else:  # It's a file
            with open(path, "w") as f:
                f.write(content)

# Execute the script
if __name__ == "__main__":
    base_path = os.path.join(os.getcwd(), "lib")  # Start from the current working directory
    create_structure(base_path, structure)
    print("Project structure created successfully!")
