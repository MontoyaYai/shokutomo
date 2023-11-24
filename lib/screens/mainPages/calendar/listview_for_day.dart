import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
import 'package:shokutomo/screens/mainPages/calendar/data/fetch_myproducts.dart';
import 'package:shokutomo/screens/mainPages/calendar/edit_dialog.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';

class ListViewForDay extends StatefulWidget {
  final List<MyProducts> getProductsForDay;
  final DateTime selectedDay;
  final Function(String, DateTime) onDelete;
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
  // ignore: no_logic_in_create_state
  ListViewForDayState createState() => ListViewForDayState(
      getProductsForDay: getProductsForDay, selectedDay: selectedDay);
}

class ListViewForDayState extends State<ListViewForDay> {
  List<MyProducts> getProductsForDay;
  final DateTime selectedDay;

  ListViewForDayState(
      {Key? key, required this.getProductsForDay, required this.selectedDay});

  void updateProductsAndCalendar(DateTime selectedDate) {
    Map<DateTime, List<MyProducts>> products =
        FetchMyProductsFromDatabase().getProducts();
    setState(() {
      getProductsForDay = products[DateTime(
              selectedDate.year, selectedDate.month, selectedDate.day)] ??
          [];
    });
    widget.onUpdateCalendar();
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
                      await FirebaseServices().deleteMyProduct(no, expiredDate);
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
                      await FirebaseServices().addOrUpdateProductInShopList(
                        ShopList(
                            name: getProductsForDay[index].name,
                            image: getProductsForDay[index].image,
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
                    ],
                  ),
                  leading: Image.asset("assets/img/$image"),
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
