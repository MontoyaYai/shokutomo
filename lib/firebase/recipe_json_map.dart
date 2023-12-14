class Recipe {
  String recipeName;
  String recipeNo;
  int cookTime;
  String difficult;
  String quantity;
  String recipeCategory;
  String image;
  bool favoriteStatus;
  List<Ingredient> ingredients;

  Recipe({
    required this.recipeName,
    required this.recipeNo,
    required this.cookTime,
    required this.difficult,
    required this.quantity,
    required this.recipeCategory,
    required this.image,
    required this.favoriteStatus,
    required this.ingredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipe_name': recipeName,
      'recipe_no': recipeNo,
      'cook_time': cookTime,
      'difficult': difficult,
      'quantity': quantity,
      'recipe_category': recipeCategory,
      'image': image,
      'favorite_status': favoriteStatus,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      recipeName: map['recipe_name'],
      recipeNo: map['recipe_no'],
      cookTime: map['cook_time'],
      difficult: map['difficult'],
      quantity: map['quantity'],
      recipeCategory: map['recipe_category'],
      image: map['image'],
      favoriteStatus: map['favorite_status'],
      ingredients: (map['ingredients'] as List<dynamic>? ?? [])
        .map((ingredient) => Ingredient.fromMap(ingredient))
        .toList(),
    );
  }
}

class Ingredient {
  String ingredientName;
  String quantityGram;

  Ingredient({
    required this.ingredientName,
    required this.quantityGram,
  });

  Map<String, dynamic> toMap() {
    return {
      'ingredient_name': ingredientName,
      'quantity_gram': quantityGram,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      ingredientName: map['ingredient_name'],
      quantityGram: map['quantity_gram'],
    );
  }
}
