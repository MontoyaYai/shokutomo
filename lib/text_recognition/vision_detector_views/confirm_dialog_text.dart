import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import './edit_dialog_text.dart';
import './text_detector_view.dart';

class InsertTextItemsConfirm extends StatefulWidget {
  final Function() onUpdate;
  const InsertTextItemsConfirm({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  InsertTextItemsConfirmState createState() => InsertTextItemsConfirmState();
}

class InsertTextItemsConfirmState extends State<InsertTextItemsConfirm> {
  InsertTextItemsConfirmState({Key? key});
  List<MyProducts> insertProducts = [];

  Future fetchPurchasedProducts() async {
    insertProducts = [];
    for (var product in productsList) {
      insertProducts.add(MyProducts(
          no: product.no,
          name: product.name,
          quantity: product.quantity,
          gram: product.gram,
          image: product.image,
          expiredDate: product.expiredDate,
          purchasedDate: product.purchasedDate));
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
                      // trailing:
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return MyProdoctEditDialog(
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
                          for (var product in insertProducts) {
                            insertIntoMyProduct(product);
                          }
                          Navigator.pop(context);
                          productsList.clear();
                          update();
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

  void insertIntoMyProduct(MyProducts product) async {
    await FirebaseServices().addOrUpdateProductInMyProduct(product);
    widget.onUpdate();
  }
}
