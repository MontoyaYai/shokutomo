import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
import 'package:shokutomo/screens/mainPages/calendar/edit_dialog.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<MyProducts> myProducts = [];
  int? selectedEntryIndex;

  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;

  @override
  void initState() {
    super.initState();
    fetchMyProducts();
  }

  void fetchMyProducts() async {
    myProducts = await FirebaseServices().getFirebaseMyProducts();
    setState(() {});
  }

  void insertIntoShopList(String no, int quantity, int gram, String name, String image, ) async {
    await FirebaseServices().insertOrUpdateIntoShopList(
      ShopList(productNo: no, name: name, image: image, quantity: quantity, gram: gram, status: 0),
    );
  }

  void _deleteProduct(MyProducts product) async {
    await FirebaseServices().deleteMyProduct(product.no, product.expiredDate);
    fetchMyProducts();
  }

  void updateProductsList(DateTime selectedDate) async {
    fetchMyProducts();
  }

  //数量また重量を増やす
  void incrementQuantity(int index) async {
    int quantity = myProducts[index].quantity;
    int gram = myProducts[index].gram;
    //quantityとgram、両方ともデータがある場合
    if (quantity != 0 && gram != 0) {
      num avrGram = gram / quantity;
      //quantityは1が増える, Gramは平均Gramが増える
      await FirebaseServices().updateQuantityAndGramOfMyProduct(
          myProducts[index].no,
          myProducts[index].expiredDate,
          quantity + 1,
          gram + avrGram);
    } else if (quantity != 0) {
      await FirebaseServices().updateQuantityAndGramOfMyProduct(
          myProducts[index].no, myProducts[index].expiredDate, quantity + 1, 0);
    } else if (gram != 0) {
      await FirebaseServices().updateQuantityAndGramOfMyProduct(
          myProducts[index].no, myProducts[index].expiredDate, 0, gram + 10);
    }
    fetchMyProducts();
  }

  //数量また重量を減らす
  void decrementQuantity(int index) async {
    int quantity = myProducts[index].quantity;
    int gram = myProducts[index].gram;
    //quantityとgram、両方ともデータがある場合
    if (quantity != 0 && gram != 0) {
      num avrGram = gram / quantity;
      //quantityは1が増える, Gramは平均Gramが増える
      await FirebaseServices().updateQuantityAndGramOfMyProduct(
          myProducts[index].no,
          myProducts[index].expiredDate,
          quantity - 1,
          gram - avrGram);
    } else if (quantity != 0) {
      await FirebaseServices().updateQuantityAndGramOfMyProduct(
          myProducts[index].no, myProducts[index].expiredDate, quantity - 1, 0);
    } else if (gram != 0) {
      await FirebaseServices().updateQuantityAndGramOfMyProduct(
          myProducts[index].no, myProducts[index].expiredDate, 0, gram - 10);
    }
    fetchMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            '在庫',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
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
                      const Text(
                        'まだエントリーがありません',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                      startActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
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
                              insertIntoShopList(
                                  product.no, product.quantity, product.gram, product.name, product.image);
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
                              if (product.gram != 0) Text('${product.gram}グラム'),
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
        ));
  }
}
