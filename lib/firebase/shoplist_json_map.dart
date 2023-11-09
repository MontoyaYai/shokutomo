import 'package:shokutomo/firebase/firebase_services.dart';

class ShopList {
  String productNo;
  String name;
  int quantity;
  int gram;
  String image;
  int status;

  ShopList({
    required this.productNo,
    required this.name,
    required this.quantity,
    required this.gram,
    required this.image,
    required this.status,
  });
  
    Map<String, dynamic> toMap() {
    return {
      'product_no': productNo,
      'product_name': name,
      'quantity': quantity,
      'gram': gram,
      'product_image': image,
      'status': status,
    };
  }

  factory ShopList.fromMap(Map<String, dynamic> map) {
    return ShopList(
      productNo: map['product_no'],
      name: map['product_name'],
      quantity: map['quantity'],
      gram: map['gram'],
      image: map['product_image'],
      status: map['status'],
    );
  }

 
  static Future<List<ShopList>> fetchShopList() async {
    List<ShopList> shopListData = await FirebaseServices().getAllShoppingList();// Convierte los datos de Firebase en una lista de InformationForShopList.
    List<ShopList> shopList = shopListData.map((data) {
      return ShopList.fromMap(data as Map<String, dynamic>);
    }).toList();

    return shopList;
  }
}
