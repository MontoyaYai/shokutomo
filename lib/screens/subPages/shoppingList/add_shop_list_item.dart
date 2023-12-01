import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';

class AddShopListDialog extends StatelessWidget {
  final String productNo;
  final String productName;
  final String productImage;
  final Function() onUpdate;
  const AddShopListDialog(
      {super.key,
      required this.productNo,
      required this.productName,
      required this.productImage,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    int quantity = 0; //TextFieldに入力したQuantity値
    int gram = 0; //TextFieldに入力したGram値
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(
        child: Column(children: [
          //Display the item name and image in the middle
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('assets/img/$productImage'),
              ),
              Text(
                productName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          //Display of Quantity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: '個',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                quantity = int.tryParse(value) ?? 0;
              },
            ),
          ), //Display of Quantity
          const SizedBox(height: 16.0),
          //Display of grams
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'グラム',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                gram = int.tryParse(value) ?? 0;
              },
            ),
          ), //Display of grams
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //A button to add an item to the shopping list
              TextButton(
                onPressed: () {
                  //database insertメソッドを呼び出す
                  insertShopList(productNo, quantity, gram);
                  //ShopList画面に戻る
                  Navigator.pop(context);
                },
                child: const Text('追加'),
              ), //A button to add an item to the shopping list
            ],
          ),
        ]),
      ),
    );
  }

  void insertShopList(String productNo, int quantity, int grams) async {
    ShopList shoplist = ShopList(
        productNo: productNo,
        name: productName,
        image: productImage,
        quantity: quantity,
        gram: grams,
        status: 0);
    await FirebaseServices().addOrUpdateProductInShopList(shoplist);
    //ShopList画面上にあるShopListのデータを表示するListViewをリセット
    onUpdate();
  }
}
