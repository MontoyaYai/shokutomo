import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
import 'package:shokutomo/screens/subPages/shoppingList/add_shop_list_item.dart';
import 'package:shokutomo/screens/subPages/shoppingList/confirm_dialog.dart';
import 'package:shokutomo/screens/subPages/shoppingList/edit_dialog.dart';
import 'package:provider/provider.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingList> {
  List<ShopList> shopListProducts = [];
  List<Product> product = [];
  int selectedEntryIndex = -1;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        fetchShopList();
      }
    });
  }

  Future<void> fetchShopList() async {
    product = await GetFirebaseDataToArray().productsArray();
    shopListProducts = await GetFirebaseDataToArray().shoppingListArray();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getProductName(String productNo) {
    final shopListProduct = shopListProducts.firstWhere(
      (product) => product.productNo == productNo,
    );
    return product
        .firstWhere((product) => product.productNo == shopListProduct.productNo)
        .productName;
  }

  String getProductImage(String productNo) {
    final shopListProduct = shopListProducts.firstWhere(
      (product) => product.productNo == productNo,
    );
    return product
        .firstWhere((product) => product.productNo == shopListProduct.productNo)
        .image;
  }

  String getProductNo(String productNo) {
    final product = shopListProducts.firstWhere(
      (product) => product.productNo == productNo,
    );
    return product.productNo;
  }

  void _deleteProduct(ShopList product) async {
    await FirebaseServices().deleteShopListProduct(product.productNo);
    fetchShopList();
  }

  void updatedShopList() async {
    fetchShopList();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    final TextEditingController searchController = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return Scaffold(
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
                  const SizedBox(
                      width: 8), // Espacio entre la imagen y el texto
                  const Text(
                    '買い物リスト',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/fondo_up_down.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 10.0, bottom: 8.0),
                    child: Text(
                      'アイテムの追加',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, bottom: 8.0, right: 20),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchProvider._searchText = value;
                        searchProvider.showSearchResults = true;
                        Future<List<Product>> searchResults =
                            getSearchResults(searchProvider.searchText);
                        searchResults.then((List<Product> results) {
                          searchProvider.setSearchResults(results);
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: '追加したいアイテム名を入力',
                        prefixIcon: Icon(Icons.add_circle_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  if (searchProvider._showSearchResults &&
                      searchProvider._searchResults.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchProvider._searchResults.length,
                        itemBuilder: (context, index) {
                          Product result = searchProvider._searchResults[index];
                          return ListTile(
                              title: Text(result.productName),
                              leading:
                                  Image.asset("assets/img/${result.image}"),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddShopListDialog(
                                        productNo: result.productNo,
                                        productName: result.productName,
                                        productImage: result.image,
                                        onUpdate: updatedShopList,
                                      );
                                    }).then((_) {
                                  searchProvider.showSearchResults = false;
                                  searchController.text = '';
                                });
                              });
                        },
                      ),
                    ),
                  // ListView to display SHOPLIST data
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                    color: Colors.grey,
                  ),
                  if (shopListProducts
                      .isEmpty) // Si no hay elementos en la lista de compras
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/img/noentry.png',
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: shopListProducts.length,
                        itemBuilder: (context, index) {
                          final product = shopListProducts[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                //Check when purchasing a product
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    updateProductStatus(product.productNo);
                                    updatedShopList();
                                  },
                                  backgroundColor: primaryColor,
                                  icon: Icons.check_box_outlined,
                                  foregroundColor: Colors.white,
                                  label: "購入済",
                                ),
                              ],
                            ),
                            startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  //When you want to delete item from the shopping list
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      _deleteProduct(product);
                                    },
                                    backgroundColor: Colors.red.shade500,
                                    icon: Icons.delete,
                                    label: "削除",
                                  ),
                                ]),
                            child: Card(
                              child: ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ShopListEditDialog(
                                          selectedProduct: product,
                                          productName:
                                              getProductName(product.productNo),
                                          productImage: getProductImage(
                                              product.productNo),
                                          onUpdate: updatedShopList,
                                        );
                                        // updatedShopList();
                                      });
                                  setState(() {
                                    selectedEntryIndex = index;
                                  });
                                },
                                leading: Image.asset(
                                  'assets/img/${getProductImage(product.productNo)}',
                                  width: 30,
                                  height: 30,
                                ),
                                title: Text(
                                  getProductName(product.productNo),
                                  style: TextStyle(
                                      decoration: product.status == 1
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (product.quantity == 0 &&
                                        product.gram == 0)
                                      const Text("未入力")
                                    else if (product.quantity != 0)
                                      Text('${product.quantity} 個'),
                                    if (product.quantity != 0 &&
                                        product.gram != 0)
                                      const Text(' / '),
                                    if (product.gram != 0)
                                      Text('${product.gram}グラム'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ), // ListView to display SHOPLIST data
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InsertItemsConfirm(
                                  onUpdate: updatedShopList);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                    // Cambia el color del texto del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Ajusta la esquina del botón
                          ),
                          elevation: 3, // Agrega una sombra al botón
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical:
                                  10), // Ajusta el espaciado interno del botón
                        ),
                        child: const Text(
                          "在庫に追加",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Product>> getSearchResults(String searchText) {
    return GetFirebaseDataToArray().searchProductsInArray(searchText);
  }

  void updateProductStatus(String productNo) async {
    await FirebaseServices().updateStatusOfShopList(productNo);
  }
}

//　search state を保存するクラス
class SearchProvider extends ChangeNotifier {
  String _searchText = '';
  List<Product> _searchResults = [];
  bool _showSearchResults = true;

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setSearchResults(List<Product> results) {
    _searchResults = results;
    notifyListeners();
  }

  set showSearchResults(bool value) {
    _showSearchResults = value;
    notifyListeners();
  }
}
