import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'dart:math';
import 'chat_page.dart';
import 'chat_screen.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({Key? key}) : super(key: key);

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  Future<List<MyProducts>>? myProductsFuture;
  Future<List<Product>>? productsFuture;
  List<MyProducts> selectedItems = [];

  @override
  void initState() {
    super.initState();
    myProductsFuture = fetchMyProducts();
    productsFuture = fetchProducts();
  }

  Future<List<MyProducts>> fetchMyProducts() async {
    return FirebaseServices().getFirebaseMyProducts();
  }

  Future<List<Product>> fetchProducts() async {
    // final dbHelper = DBHelper.instance;
    return FirebaseServices().getFirebaseProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'レシピ検索',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, productsSnapshot) {
            if (productsSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (productsSnapshot.hasError) {
              return Text('Error: ${productsSnapshot.error}');
            } else {
              return Center(
                child: FutureBuilder<List<MyProducts>>(
                  future: myProductsFuture,
                  builder: (context, myProductsSnapshot) {
                    if (myProductsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (myProductsSnapshot.hasError) {
                      return Text('Error: ${myProductsSnapshot.error}');
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ButtonGrid(
                          myProducts: myProductsSnapshot.data!,
                          products: productsSnapshot.data!,
                        ),
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  final List<MyProducts> myProducts;
  final List<Product> products;

  const ButtonGrid({Key? key, required this.myProducts, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CHECK :必要はない
    // Products randomProduct =
    //     getRandomProductFromMyProducts(products);

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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              _showProductsDialogBox(context, products);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/selectfood.png',
                  width: 75,
                  height: 75,
                ),
                const SizedBox(height: 8),
                const Text(
                  '好きな食材からレシピを選びましょう',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              _showDialogBox(context, myProducts);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/fridge.png",
                  width: 75,
                  height: 75,
                ),
                const SizedBox(height: 8),
                const Text(
                  '手持ち在庫からレシピを選びましょう',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              _navigateToChatScreen(context, '好きなレシピを教えてください。');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/randomfood.png',
                  width: 75,
                  height: 75,
                ),
                const SizedBox(height: 8),
                const Text(
                  'ランダムなレシピ！',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),

            ///
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );

              ///
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/food.png",
                  width: 75,
                  height: 75,
                ),
                const SizedBox(height: 8),
                const Text(
                  'チャットボットと会話する',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDialogBox(
      BuildContext context, List<MyProducts>? myProducts) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('食材を選択してください'),
          content: SizedBox(
            width: double.maxFinite,
            child: myProducts == null || myProducts.isEmpty
                ? const Text('在庫に食材がありません!')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: myProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(myProducts[index].image),
                        title: Text(myProducts[index].name),
                        onTap: () {
                          Navigator.of(context).pop();
                          _navigateToChatScreen(
                            context,
                            '${myProducts[index].name} がはいっているレシピ教えてください。',
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog box without selecting any item
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }

  void _showProductsDialogBox(BuildContext context, List<Product>? products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('食材を選択してください'),
          content: SizedBox(
            width: double.maxFinite,
            child: products == null || products.isEmpty
                ? const Text('在庫に食材がありません!')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(products[index].image),
                        title: Text(products[index].productName),
                        onTap: () {
                          Navigator.of(context).pop();
                          _navigateToChatScreen(
                            context,
                            '${products[index].productName} がはいっているレシピ教えてください。',
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog box without selecting any item
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }

  //CHECK: もう必要はない
  // Products _getRandomProduct() {
  //   return products[Random().nextInt(products.length)];
  // }

  Product getRandomProductFromMyProducts(List<Product> products) {
    if (products.isEmpty) {
      throw Exception("The list of myProducts is empty.");
    }

    // Generate a random index within the valid range of the list
    int randomIndex = Random().nextInt(products.length);

    // Return the product at the random index
    return products[randomIndex];
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
