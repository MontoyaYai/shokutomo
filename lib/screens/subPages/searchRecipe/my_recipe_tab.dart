import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myrecipe_json_map.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/add_recipe_form.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/favorite_recipe_dialog.dart';

import 'my_recipe_detail_page.dart';

class MyRecipeTab extends StatefulWidget {
  const MyRecipeTab({super.key});

  @override
  MyRecipeTabState createState() => MyRecipeTabState();
}

class MyRecipeTabState extends State<MyRecipeTab> {
  late Future<List<MyRecipe>> _recipesFuture;
   ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _recipesFuture = GetFirebaseDataToArray().myRecipesArray();
  }

    Future<void> _refreshRecipes() async {
    setState(() {
      _recipesFuture = GetFirebaseDataToArray().myRecipesArray();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
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
        )]),

      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
      
        icon: Icons.menu_book_rounded,
        activeIcon: Icons.close,
        spacing: 8.0,
        openCloseDial: isDialOpen,

        children: [
          SpeedDialChild(
            child: const Icon(Icons.favorite),
            onTap: () {
              showDialog(
              context: context, 
              builder: (context)=> FavoriteRecipesDialog(),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.refresh),
            onTap: () {
              _refreshRecipes();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_circle_outline_rounded),
            onTap: () async{
             final resultForm = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeForm(),
              ),
            );
            if (resultForm == true) {
              _refreshRecipes();}
            },
          ),
        ],
      ),
        
    );
  }
}
