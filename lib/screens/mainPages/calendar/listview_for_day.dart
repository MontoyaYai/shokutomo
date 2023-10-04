import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shokutomo/database/delete_activity.dart';
import 'package:shokutomo/database/insert_activity.dart';
import 'package:shokutomo/database/update_activity.dart';
import 'package:shokutomo/information_format/shop_list.dart';
import 'package:shokutomo/screens/mainPages/calendar/data/fetch_myproducts.dart';
import 'package:shokutomo/screens/mainPages/calendar/edit_dialog.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';

class ListViewForDay extends StatefulWidget {
  final List<MyProductWithNameAndImage> getProductsForDay;
  final DateTime selectedDay;
  final Function(int, DateTime) onDelete;
  final Function() onUpdateCalendar;
  final Function() onUpdateProduct;

  const ListViewForDay(
      {Key? key,
      required this.getProductsForDay,
      required this.selectedDay,
      required this.onDelete,
      required this.onUpdateCalendar,
      required this.onUpdateProduct})
      : super(key: key);

  @override
  ListViewForDayState createState() => ListViewForDayState(
      getProductsForDay: getProductsForDay, selectedDay: selectedDay);
}

class ListViewForDayState extends State<ListViewForDay> {
  List<MyProductWithNameAndImage> getProductsForDay;
  final DateTime selectedDay;

  ListViewForDayState(
      {Key? key, required this.getProductsForDay, required this.selectedDay});

  void updateProductsAndCalendar(DateTime selectedDate) {
    Map<DateTime, List<MyProductWithNameAndImage>> products =
        FetchMyProductsFromDatabase().getProducts();
    setState(() {
      getProductsForDay = products[DateTime(
              selectedDate.year, selectedDate.month, selectedDate.day)] ??
          [];
    });
    widget.onUpdateCalendar();
  }

  //数量また重量を増やす
  void incrementQuantity(int index) async {
    int quantity = getProductsForDay[index].quantity;
    int gram = getProductsForDay[index].gram;
    //quantityとgram、両方ともデータがある場合
    if (quantity != 0 && gram != 0) {
      num avrGram = gram / quantity;
      //quantityは1が増える, Gramは平均Gramが増える
      await UpdateActivity().UpdateQuantityAndGramOfMyProduct(
          getProductsForDay[index].no,
          getProductsForDay[index].expiredDate,
          ++quantity,
          gram += avrGram.toInt());
    } else if (quantity != 0) {
      await UpdateActivity().UpdateQuantityAndGramOfMyProduct(
          getProductsForDay[index].no,
          getProductsForDay[index].expiredDate,
          ++quantity,
          0);
    } else if (gram != 0) {
      await UpdateActivity().UpdateQuantityAndGramOfMyProduct(
          getProductsForDay[index].no,
          getProductsForDay[index].expiredDate,
          0,
          gram += 10);
    }
    setState(() {
      getProductsForDay[index].quantity = quantity;
      getProductsForDay[index].gram = gram;
    });
  }

  //数量また重量を減らす
  void decrementQuantity(int index) async {
    int quantity = getProductsForDay[index].quantity;
    int gram = getProductsForDay[index].gram;
    //quantityとgram、両方ともデータがある場合
    if (quantity != 0 && gram != 0) {
      num avrGram = gram / quantity;
      //quantityは1が増える, Gramは平均Gramが増える
      await UpdateActivity().UpdateQuantityAndGramOfMyProduct(
          getProductsForDay[index].no,
          getProductsForDay[index].expiredDate,
          --quantity,
          gram -= avrGram.toInt());
    } else if (quantity != 0) {
      await UpdateActivity().UpdateQuantityAndGramOfMyProduct(
          getProductsForDay[index].no,
          getProductsForDay[index].expiredDate,
          --quantity,
          0);
    } else if (gram != 0) {
      await UpdateActivity().UpdateQuantityAndGramOfMyProduct(
          getProductsForDay[index].no,
          getProductsForDay[index].expiredDate,
          0,
          gram -= 10);
    }
    setState(() {
      getProductsForDay[index].quantity = quantity;
      getProductsForDay[index].gram = gram;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    return Column(
      children: [
        Flexible(
            child: ListView.builder(
          itemCount: getProductsForDay.length,
          itemBuilder: (context, index) {
            final product = getProductsForDay[index];
            final no = product.no;
            final name = product.name;
            final quantity = product.quantity;
            final gram = product.gram;
            final image = product.image;
            final expiredDate = product.expiredDate;

            return Slidable(
                //SHOPLISTへinsertせずにMYPRODUCTから消す
                startActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    onPressed: (BuildContext context) async {
                      await DeleteActivity().deleteMyProduct(no, expiredDate);
                      widget.onUpdateCalendar();
                    },
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    label: "削除",
                  )
                ]),
                endActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    onPressed: (BuildContext context) async {
                      // Make a copy of the item in the shoplist database
                      await InsertActivity().insertOrUpdateIntoShopList(
                        ShopList(
                            productNo: getProductsForDay[index].no,
                            quantity: getProductsForDay[index].quantity,
                            gram: getProductsForDay[index].gram,
                            status: 0),
                      );
                      // Delete the item from the "MyProduct" list
                      widget.onDelete(no, expiredDate);
                    },
                    backgroundColor: primaryColor,
                    icon: Icons.shopping_cart_checkout,
                    label: "使い切り",
                  )
                ]),
                child: ListTile(
                  // ListViewのアイテム
                  title: Text(name), //商品名
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (quantity == 0 && gram == 0)
                        const Text("未入力")
                      else if (quantity != 0)
                        Text('$quantity個'),
                      if (quantity != 0 && gram != 0) const Text(' / '),
                      if (gram != 0) Text('$gramグラム'),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              incrementQuantity(index);
                            },
                            child: const Icon(Icons.arrow_drop_up),
                          ),
                          GestureDetector(
                            onTap: () {
                              decrementQuantity(index);
                            },
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                        ],
                      )
                    ],
                  ),
                  leading: Image.asset(image),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditDialog(
                          product: getProductsForDay[index],
                          onUpdate: updateProductsAndCalendar,
                        );
                      },
                    );
                  },
                ));
          },
        )),
        //画面スワイプ用の空間
        const SizedBox(height: 25)
      ],
    );
  }
}
