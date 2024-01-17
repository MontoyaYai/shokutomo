import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myrecipe_json_map.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/add_recipe_form.dart';

import 'recipe_detail_page.dart';

class MyRecipeTab extends StatefulWidget {
  const MyRecipeTab({super.key});

  @override
  MyRecipeTabState createState() => MyRecipeTabState();
}

class MyRecipeTabState extends State<MyRecipeTab> {
  late Future<List<MyRecipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = GetFirebaseDataToArray().myRecipesArray();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FutureBuilder<List<MyRecipe>>(
            future: _recipesFuture,
            builder: (context, recipeSnapshot) {
              if (recipeSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (recipeSnapshot.hasError) {
                return Text('Error: ${recipeSnapshot.error}');
              } else {
                final recipes = recipeSnapshot.data!;
                return GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(20.0),
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    for (var recipe in recipes)
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                          if (result == true) {
                            // Actualiza la lista de recetas si se borró una receta
                            setState(() {
                              _recipesFuture =
                                  GetFirebaseDataToArray().myRecipesArray();
                            });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Imagen del producto
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(recipe.image)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Texto con el nombre del producto
                            Flexible(
                              child: Text(
                                recipe.recipeName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecipeForm()),
            );
          },
          child: const Text('レーシピを追加する',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
