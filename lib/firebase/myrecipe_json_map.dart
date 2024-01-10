class MyRecipe {
  String recipeName;
  String recipeNo;
  String howTo;
  int cookTime;
  String difficult;
  String quantity;
  String recipeCategory;
  String image;
  bool favoriteStatus;
  List<Ingredient> ingredients;

  MyRecipe({
    required this.recipeName,
    required this.recipeNo,
    required this.howTo,
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
      'how_to': howTo,
      'cook_time': cookTime,
      'difficult': difficult,
      'quantity': quantity,
      'recipe_category': recipeCategory,
      'image': image,
      'favorite_status': favoriteStatus,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
    };
  }

  factory MyRecipe.fromMap(Map<String, dynamic> map) {
    return MyRecipe(
      recipeName: map['recipe_name'],
      recipeNo: map['recipe_no'],
      howTo: map['how_to'],
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
