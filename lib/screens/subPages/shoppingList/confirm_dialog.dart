import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
import 'package:shokutomo/screens/subPages/shoppingList/edit_dialog.dart';

class InsertItemsConfirm extends StatefulWidget {
  final Function() onUpdate;
  const InsertItemsConfirm({super.key, required this.onUpdate});

  @override
  InsertItemsConfirmState createState() => InsertItemsConfirmState();
}

class InsertItemsConfirmState extends State<InsertItemsConfirm> {
  InsertItemsConfirmState({Key? key});
  List<ShopList> insertProducts = [];

  Future fetchPurchasedProducts() async {
    List<ShopList> purchasedProducts =
        await FirebaseServices().getBoughtProduct();
    insertProducts = [];
    for (var product in purchasedProducts) {
      insertProducts.add(ShopList(
        productNo: product.productNo,
        name: product.name,
        quantity: product.quantity,
        gram: product.gram,
        image: product.image,
        status: 1,
      ));
    }
  }

  void update() {
    setState(() {});
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPurchasedProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("ERROR");
        } else {
          if (insertProducts.isEmpty) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/img/noentry.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "購入済商品がありません",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
              decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/fondo_up_down.png'),
              fit: BoxFit.fill,
            ),
          ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "以下の情報を在庫へ登録します",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var product in insertProducts)
                      ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          product.quantity != 0 && product.gram != 0
                              ? "${product.quantity}個 / ${product.gram}グラム"
                              : product.quantity > product.gram
                                  ? "${product.quantity}個"
                                  : "${product.gram}グラム",
                        ),
                        // trailing:
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ShopListEditDialog(
                                    selectedProduct: product,
                                    productName: product.name,
                                    productImage: product.image,
                                    onUpdate: update);
                              });
                        },
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("キャンセル"),
                        ),
                        TextButton(
                          onPressed: () {
                            insertIntoMyProduct();
                            Navigator.pop(context);
                          },
                          child: const Text("確定"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  void insertIntoMyProduct() async {
    await FirebaseServices().insertMyProductFromShopList();
    widget.onUpdate();
  }
}
