import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shokutomo/database/delete_activity.dart';
import 'package:shokutomo/database/insert_activity.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';
import 'package:shokutomo/information_format/my_products.dart';

class EditInsertInfoDialog extends StatefulWidget {
  final MyProductWithNameAndImage product;
  final Function() onUpdate;

  const EditInsertInfoDialog(
      {super.key, required this.product, required this.onUpdate});

  @override
  EditInsertInfoDialogState createState() =>
      EditInsertInfoDialogState(product: product);
}

class EditInsertInfoDialogState extends State<EditInsertInfoDialog> {
  final MyProductWithNameAndImage product;
  bool isChangeableExpiredDate = true;

  EditInsertInfoDialogState({Key? key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(product.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //商品のイメージを表示するボックス
            const SizedBox(height: 8.0),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ), //商品のイメージを表示するボックス

            //購入日を表示
            const Text(
              '購入日',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
            ),
            Row(
              children: [
                //year
                const SizedBox(height: 8.0),
                Expanded(
                    child: DropdownButton<int>(
                        items:
                            List<DropdownMenuItem<int>>.generate(50, (index) {
                          final int year = DateTime.now().year - 1 + index;
                          return DropdownMenuItem<int>(
                              value: year, child: Text("$year"));
                        }),
                        value: product.purchasedDate.year,
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              DateTime changedValue = DateTime(
                                  newValue,
                                  product.purchasedDate.month,
                                  product.purchasedDate.day);
                              if (changedValue.isAfter(product.expiredDate)) {
                                isChangeableExpiredDate = false;
                              } else {
                                product.purchasedDate = changedValue;
                                isChangeableExpiredDate = true;
                              }
                            }
                          });
                        })), //year Drop Down

                const SizedBox(height: 8.0),
                Expanded(
                    child: DropdownButton<int>(
                        items:
                            List<DropdownMenuItem<int>>.generate(12, (index) {
                          final int month =
                              DateTime.utc(2023, 01, 01).month + index;
                          return DropdownMenuItem<int>(
                              value: month, child: Text("$month"));
                        }),
                        value: product.purchasedDate.month,
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              DateTime changedValue = DateTime(
                                  product.purchasedDate.year,
                                  newValue,
                                  product.purchasedDate.day);
                              if (changedValue.isAfter(product.expiredDate)) {
                                isChangeableExpiredDate = false;
                              } else {
                                product.purchasedDate = changedValue;
                                isChangeableExpiredDate = true;
                              }
                            }
                          });
                        })),

                const SizedBox(height: 8.0),
                Expanded(
                    child: DropdownButton<int>(
                        items:
                            List<DropdownMenuItem<int>>.generate(31, (index) {
                          final int day =
                              DateTime.utc(2023, 01, 01).day + index;
                          return DropdownMenuItem<int>(
                              value: day, child: Text("$day"));
                        }),
                        value: product.purchasedDate.day,
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              DateTime changedValue = DateTime(
                                  product.purchasedDate.year,
                                  product.purchasedDate.month,
                                  newValue);
                              if (changedValue.isAfter(product.expiredDate)) {
                                isChangeableExpiredDate = false;
                              } else {
                                product.purchasedDate = changedValue;
                                isChangeableExpiredDate = true;
                              }
                            }
                          });
                        })),
              ],
            ), //購入日を表示

            //賞味期限表示
            const SizedBox(height: 8.0),
            const Text(
              '消費・賞味期限日',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
            ),
            Row(
              children: [
                //year
                const SizedBox(height: 8.0),
                Expanded(
                    child: DropdownButton<int>(
                        items:
                            List<DropdownMenuItem<int>>.generate(50, (index) {
                          final int year = DateTime.now().year - 1 + index;
                          return DropdownMenuItem<int>(
                              value: year, child: Text("$year"));
                        }),
                        value: product.expiredDate.year,
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              DateTime changedValue = DateTime(
                                  newValue,
                                  product.expiredDate.month,
                                  product.expiredDate.day);
                              if (changedValue
                                  .isBefore(product.purchasedDate)) {
                                isChangeableExpiredDate = false;
                              } else {
                                product.expiredDate = changedValue;
                                isChangeableExpiredDate = true;
                              }
                            }
                          });
                        })), //year Drop Down

                const SizedBox(height: 8.0),
                Expanded(
                    child: DropdownButton<int>(
                        items:
                            List<DropdownMenuItem<int>>.generate(12, (index) {
                          final int month =
                              DateTime.utc(2023, 01, 01).month + index;
                          return DropdownMenuItem<int>(
                              value: month, child: Text("$month"));
                        }),
                        value: product.expiredDate.month,
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              DateTime changedValue = DateTime(
                                  product.expiredDate.year,
                                  newValue,
                                  product.expiredDate.day);
                              if (changedValue
                                  .isBefore(product.purchasedDate)) {
                                isChangeableExpiredDate = false;
                              } else {
                                product.expiredDate = changedValue;
                                isChangeableExpiredDate = true;
                              }
                            }
                          });
                        })),

                const SizedBox(height: 8.0),
                Expanded(
                    child: DropdownButton<int>(
                        items:
                            List<DropdownMenuItem<int>>.generate(31, (index) {
                          final int day =
                              DateTime.utc(2023, 01, 01).day + index;
                          return DropdownMenuItem<int>(
                              value: day, child: Text("$day"));
                        }),
                        value: product.expiredDate.day,
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              DateTime changedValue = DateTime(
                                  product.expiredDate.year,
                                  product.expiredDate.month,
                                  newValue);
                              if (changedValue
                                  .isBefore(product.purchasedDate)) {
                                isChangeableExpiredDate = false;
                              } else {
                                product.expiredDate = changedValue;
                                isChangeableExpiredDate = true;
                              }
                            }
                          });
                        })),
              ],
            ), //賞味期限表示
            if (!isChangeableExpiredDate)
              const Text(
                "購入日より前の賞味期限を設定することが出来ません！",
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            //Quantity表示
            const SizedBox(height: 8.0),
            TextFormField(
              initialValue: product.quantity.toString(),
              decoration: const InputDecoration(labelText: "個数"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                product.quantity = int.tryParse(value) ?? product.quantity;
              },
            ), //Quantity表示
            //grams表示
            const SizedBox(height: 8.0),
            TextFormField(
              initialValue: product.gram.toString(),
              decoration: const InputDecoration(labelText: "グラム"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                product.gram = int.tryParse(value) ?? product.gram;
              },
            ), //grams表示
          ],
        ),
      ),
      actions: [
        //変更せず前の画面へ戻る
        TextButton(
            onPressed: () {
              //前のカレンダーに戻る
              Navigator.pop(context);
            },
            child: const Text("キャンセル")), //変更せず前の画面へ戻る
        //この商品のみ保存する
        TextButton(
            onPressed: () {
              InsertActivity().insertOrUpdateProducts(MyProducts(
                  productNo: product.no,
                  quantity: product.quantity,
                  gram: product.gram,
                  purchasedDate: product.purchasedDate.toString(),
                  expiredDate: product.expiredDate.toString()));
              DeleteActivity().deleteShopListProduct(product.no);
              Navigator.pop(context);
              widget.onUpdate();
            },
            child: const Text("保存")), //この商品のみ保存する
      ],
    );
  }
}
