import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myrecipe_json_map.dart';
import 'package:shokutomo/firebase/recipe_json_map.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/my_recipe_detail_page.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/recomended_recipe_detail_page.dart';

class FavoriteRecipesDialog extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const FavoriteRecipesDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(
          child: Text(
            'お気に入りレシピ',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
      ),
      children: [
        _buildFavoriteRecipesList(
          title: 'マイレシピ',
          future: GetFirebaseDataToArray().myRecipesArray(),
          onTapRecipe: (recipe) {
            _navigateToRecipeDetailPage(context, recipe, isMyRecipe: true);
          },
        ),
        _buildFavoriteRecipesList(
          title: 'おすすめレシピ！',
          future: GetFirebaseDataToArray().recipesArray(),
          onTapRecipe: (recipe) {
            _navigateToRecipeDetailPage(context, recipe, isMyRecipe: false);
          },
        ),
      ],
    );
  }

Widget _buildFavoriteRecipesList({
  required String title,
  required Future<List<dynamic>> future,
  required void Function(dynamic) onTapRecipe,
}) {
  return FutureBuilder<List<dynamic>>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        final recipes = snapshot.data ?? [];
        final favoriteRecipes = recipes.where((recipe) => recipe.favoriteStatus == true).toList();

        return SizedBox(
          height: 200, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var recipe in favoriteRecipes)
                       InkWell(
                          onTap: () {
                            onTapRecipe(recipe);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _getImageForRecipe(recipe),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Flexible(
                                child: Text(
                                  recipe.recipeName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
  
}
void _navigateToRecipeDetailPage(BuildContext context, dynamic recipe, {required bool isMyRecipe}) {
    if (isMyRecipe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(recipe: recipe as MyRecipe),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecomendatedRecipeDetailPage(recipe: recipe as Recipe),
        ),
      );
    }
  }
}

ImageProvider _getImageForRecipe(dynamic recipe) {
  if (recipe is MyRecipe) {
    // Es una receta de MyRecipe
    return FileImage(File(recipe.image));
  } else if (recipe is Recipe) {
    // Es una receta de Recipe
    return AssetImage("assets/img/${recipe.image}");
  } else {
    // Manejar otros casos o lanzar una excepción según sea necesario
    throw Exception("レシピタイプは未定です");
  }
}
