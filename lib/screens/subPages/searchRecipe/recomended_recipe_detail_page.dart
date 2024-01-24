import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/recipe_json_map.dart';

class RecomendatedRecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const  RecomendatedRecipeDetailPage({super.key, required this.recipe});

  @override
  RecomendatedRecipeDetailState createState() => RecomendatedRecipeDetailState();
}

class RecomendatedRecipeDetailState extends State<RecomendatedRecipeDetailPage> {
  bool favoriteStatus = false;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    favoriteStatus = widget.recipe.favoriteStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.recipeName),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                favoriteStatus = !favoriteStatus;
                widget.recipe.favoriteStatus = favoriteStatus;
              });
               await firebaseServices.updateRecipeFavoriteStatus(widget.recipe.recipeNo, favoriteStatus);
            },
            icon: Icon(
              Icons.favorite,
              color: favoriteStatus ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/img/${widget.recipe.image}")
                // image: FileImage(File(widget.recipe.image)),
              ),
            ),
          ),
          const SizedBox(height: 22.0),
          Text(
            widget.recipe.recipeName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 93, 93)),
          ),
          const SizedBox(height: 4),
          Text(
            widget.recipe.recipeCategory,
            style:
                TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconWithText(
                    Icons.signal_cellular_alt, widget.recipe.difficult),
                const SizedBox(width: 8.0),
                _buildIconWithText(Icons.people, widget.recipe.quantity),
                const SizedBox(width: 8.0),
                _buildIconWithText(
                    Icons.access_time, widget.recipe.cookTime.toString()),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          const Text(
            '材料',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.recipe.ingredients.length,
            itemExtent: 40.0,
            itemBuilder: (context, index) {
              final ingredient = widget.recipe.ingredients[index];
              return ListTile(
                title: Row(
                  children: [
                    Text(ingredient.quantityGram),
                    const SizedBox(width: 8.0),
                    Text(ingredient.ingredientName),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32.0),
          const Text(
            '手順',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12.0),
          Text(widget.recipe.howTo),
        ],
      ),
    );
  }

  _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 94, 93, 93)),
        const SizedBox(width: 8.0),
        Text(text),
      ],
    );
  }
}
