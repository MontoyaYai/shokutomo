import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
import 'package:shokutomo/screens/mainPages/calendar/edit_dialog.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  InventoryPageState createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage> {
  List<MyProducts> myProducts = [];
  int? selectedEntryIndex;

  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;
  // タイマーを設定
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        fetchMyProducts();
      }
    });
  }

  void fetchMyProducts() async {
    myProducts = await GetFirebaseDataToArray().myProductsArray();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
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

  void insertIntoShopList(
    String no,
    int quantity,
    int gram,
    String name,
    String image,
  ) async {
    await FirebaseServices().addOrUpdateProductInShopList(
      ShopList(
          productNo: no,
          name: name,
          image: image,
          quantity: quantity,
          gram: gram,
          status: 0),
    );
  }

  void _deleteProduct(MyProducts product) async {
    await FirebaseServices().deleteMyProduct(product.no, product.expiredDate);
    fetchMyProducts();
  }

  void updateProductsList(DateTime selectedDate) async {
    fetchMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
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
              const SizedBox(width: 8), // Espacio entre la imagen y el texto
              const Text(
                '在庫',
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
            children: [
              const SizedBox(
                height: 3,
              ),
              if (myProducts.isEmpty)
                Flexible(
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
              else // Si hay elementos en el inventario
                Flexible(
                  child: ListView.builder(
                    itemCount: myProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = myProducts[index];
                      return Slidable(
                        //SHOPLISTへinsertせずにMYPRODUCTから消す
                        startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  _deleteProduct(product);
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: "削除",
                              )
                            ]),
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                // Make a copy of the item in the shoplist database
                                insertIntoShopList(product.no, product.quantity,
                                    product.gram, product.name, product.image);
                                // Delete the item from the "product" list
                                _deleteProduct(product);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              backgroundColor: primaryColor,
                              icon: Icons.shopping_cart_checkout,
                              label: "使い切り",
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditDialog(
                                      product: product,
                                      onUpdate: updateProductsList,
                                    );
                                  });
                              setState(() {
                                selectedEntryIndex = index;
                              });
                            },
                            leading: Image.asset(
                              "assets/img/${product.image}",
                              width: 30,
                              height: 30,
                            ),
                            title: Text(product.name),
                            subtitle: Text(
                              product.expiredDate.toString().substring(0, 10),
                              style: const TextStyle(
                                fontSize: 12, // Adjust the font size if needed
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (product.quantity == 0 && product.gram == 0)
                                  const Text("未入力")
                                else if (product.quantity != 0)
                                  Text('${product.quantity} 個'),
                                if (product.quantity != 0 && product.gram != 0)
                                  const Text(' / '),
                                if (product.gram != 0)
                                  Text('${product.gram}グラム'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              //画面スワイプ用の空間
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ));
  }
}
