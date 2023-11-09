import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/screens/subPages/shoppingList/edit_info_of_items_will_insert.dart';

class InsertItemsConfirm extends StatefulWidget {
  final Function() onUpdate;
  const InsertItemsConfirm({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  InsertItemsConfirmState createState() => InsertItemsConfirmState();
}

class InsertItemsConfirmState extends State<InsertItemsConfirm> {
  InsertItemsConfirmState({Key? key});
  List<MyProducts> insertProducts = [];

  Future fetchPurchasedProducts() async {
    List<ShopList> purchasedProducts =
        await FirebaseServices().getBoughtProduct();
    insertProducts = [];
    for (var product in purchasedProducts) {
      int useBy = await FirebaseServices().getUseByOrBestBy(product.productNo);
      DateTime now = DateTime.now();
      DateTime expired = now.add(Duration(days: useBy));
      insertProducts.add(MyProducts(
          no: product.productNo,
          name: product.name,
          quantity: product.quantity,
          gram: product.gram,
          image: product.image,
          expiredDate: DateTime(expired.year, expired.month, expired.day),
          purchasedDate: DateTime(now.year, now.month, now.day)));
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
                      trailing:
                          Text(product.expiredDate.toString().substring(0, 10)),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditInsertInfoDialog(
                                  product: product, onUpdate: update);
                            });
                      },
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // キャンセルボタンを押して、前の画面へ戻る
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("キャンセル"),
                      ),
                      // 確定ボタン：MyProductにデータをインサートし、ListViewをupdateする
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
