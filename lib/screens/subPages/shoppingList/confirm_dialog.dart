import 'package:flutter/material.dart';
import 'package:shokutomo/database/get_activity.dart';
import 'package:shokutomo/database/insert_activity.dart';
import 'package:shokutomo/information_format/information_for_shop_list.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';
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
  List<MyProductWithNameAndImage> insertProducts = [];

  Future fetchPurchasedProducts() async {
    List<InformationForShopList> purchasedProducts =
        await GetActivity().getBoughtProduct();
    insertProducts = [];
    for (var product in purchasedProducts) {
      int useBy = await GetActivity().getUseByOrBestBy(product.no);
      DateTime now = DateTime.now();
      DateTime expired = now.add(Duration(days: useBy));
      insertProducts.add(MyProductWithNameAndImage(
          no: product.no,
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
    await InsertActivity().insertMyProductFromShopList();
    widget.onUpdate();
  }
}
