import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';

import 'package:shokutomo/firebase/recipe_json_map.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/my_recipe_tab.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/recomended_recipe_detail_page.dart';
import 'chat_page.dart';
import 'chat_screen.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  SearchRecipeState createState() => SearchRecipeState();
}

class SearchRecipeState extends State<SearchRecipe> {
  late Future<List<Recipe>> recipesFuture;
  late Future<List<MyProducts>> productsFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = fetchRecipe();
    productsFuture = fetchProducts();
  }

  Future<List<Recipe>> fetchRecipe() async {
    return GetFirebaseDataToArray().recipesArray();
  }

  Future<List<MyProducts>> fetchProducts() async {
    return GetFirebaseDataToArray().myProductsArray();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo_sushi.png',
                width: 30, // ajusta el ancho según sea necesario
                height: 30, // ajusta la altura según sea necesario
              ),
              const SizedBox(width: 8), // Espacio entre la imagen y el texto
              const Text(
                'レシピブック',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    Text('レシピ検索'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book),
                    Text('マイレシピ'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildRecipeSearchTab(),
            const Center(
              child: MyRecipeTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSearchTab() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/fondo_down.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: _buildButtonGrid(),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0), // Agregado espacio desde la izquierda
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'おすすめ！',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: recipesFuture,
              builder: (context, recipeSnapshot) {
                if (recipeSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (recipeSnapshot.hasError) {
                  return Text('Error: ${recipeSnapshot.error}');
                } else {
                  return _buildRecommendedRecipesList(recipeSnapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildButtonGrid() {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 20.0,
      children: [
        InkWell(
          onTap: () {
            _showDialogBox(context, productsFuture);
          },
          child: Ink.image(
            image: const AssetImage('assets/img/select_search.png'),
            fit: BoxFit.cover,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
          },
          child: Ink.image(
            image: const AssetImage('assets/img/chatbot.png'),
            fit: BoxFit.fill,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildRecommendedRecipesList(List<Recipe> recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecomendatedRecipeDetailPage(recipe: recipes[index])),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Imagen a la izquierda
                Container(
                  width: 50.0, // Reducido el tamaño
                  height: 45.0, // Reducido el tamaño
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/img/${recipes[index].image}"),
                    ),
                  ),
                ),
                // Separación entre la imagen y el texto
                const SizedBox(width: 12.0), // Reducido el espacio
                // Título alineado a la izquierda
                Expanded(
                  child: Text(
                    recipes[index].recipeName,
                    style: const TextStyle(
                      fontSize: 16.0, // Reducido el tamaño de la fuente
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialogBox(
      BuildContext context, Future<List<MyProducts>> myProductsFuture) {
    myProductsFuture.then((myProducts) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('食材を選択してください'),
            content: SizedBox(
              width: double.maxFinite,
              child: myProducts.isEmpty
                  ? const Text('在庫に食材がありません!')
                  : _buildMyProductsList(myProducts),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildMyProductsList(List<MyProducts> products) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset("assets/img/${products[index].image}"),
          title: Text(products[index].name),
          onTap: () {
            Navigator.of(context).pop();
            _navigateToChatScreen(
              context,
              '${products[index].name} がはいっているレシピ教えてください。',
            );
          },
        );
      },
    );
  }

  void _navigateToChatScreen(BuildContext context, String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(initialMessage: message),
      ),
    );
  }
}
