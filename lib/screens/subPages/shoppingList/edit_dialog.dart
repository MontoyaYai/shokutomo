import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';


class ShopListEditDialog extends StatelessWidget {
  final ShopList selectedProduct;
  final String productName;
  final String productImage;
  final Function() onUpdate;
  const ShopListEditDialog(
      {Key? key,
      required this.selectedProduct,
      required this.productName,
      required this.productImage,
      required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/img/$productImage'),
                ),
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            //quantity
            const SizedBox(
              height: 8,
            ),
            //Quantity
            TextFormField(
              initialValue: selectedProduct.quantity.toString(),
              decoration: const InputDecoration(labelText: "個"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                selectedProduct.quantity =
                    int.tryParse(value) ?? selectedProduct.quantity;
              },
            ), //Quantity
            //gram
            const SizedBox(
              height: 8.0,
            ),
            //Gram
            TextFormField(
              initialValue: selectedProduct.gram.toString(),
              decoration: const InputDecoration(labelText: "グラム"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                selectedProduct.gram =
                    int.tryParse(value) ?? selectedProduct.gram;
              },
            ), //gram
          ],
        ),
      ),
      actions: [
        //Cancel Button : ShopList表示画面へ戻る
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("キャンセル")),
        //Edit Button : update ShopList table
        TextButton(
            onPressed: () {
              updateProduct(selectedProduct);
              onUpdate();
              Navigator.pop(context);
            },
            child: const Text("編集aaaa")),
      ],
    );
  }

  void updateProduct(ShopList product) async {
    await FirebaseServices().addOrUpdateProductInShopList(product);
  }
}
