import 'package:shokutomo/database/sql.dart';

class ShopList {
  int productNo;
  int quantity;
  int gram;
  int status;

  ShopList(
      {required this.productNo, required this.quantity, required this.gram, required this.status});

  Map<String, dynamic> toMap() {
    return {
      SQL.columnProductNo: productNo,
      SQL.columnQuantity: quantity,
      SQL.columnGram: gram,
      SQL.columnStatus: status
    };
  }

  factory ShopList.fromMap(Map<String, dynamic> map) {
    return ShopList(
      productNo: map[SQL.columnProductNo],
      quantity: map[SQL.columnQuantity],
      gram: map[SQL.columnGram],
      status: map[SQL.columnStatus]
    );
  }
}
