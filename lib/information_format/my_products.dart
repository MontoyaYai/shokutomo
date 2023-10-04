import 'package:shokutomo/database/sql.dart';

class MyProducts {
  int productNo;
  int quantity;
  int gram;
  String purchasedDate;
  String expiredDate;

  MyProducts(
      {required this.productNo,
      required this.quantity,
      required this.gram,
      required this.purchasedDate,
      required this.expiredDate});

  Map<String, dynamic> toMap() {
    return {
      SQL.columnProductNo: productNo,
      SQL.columnQuantity: quantity,
      SQL.columnGram: gram,
      SQL.columnPurchasedDay: purchasedDate,
      SQL.columnExpiredDay: expiredDate
    };
  }

  factory MyProducts.fromMap(Map<String, dynamic> map) {
    return MyProducts(
        productNo: map[SQL.columnProductNo],
        quantity: map[SQL.columnQuantity] ?? 0,
        gram: map[SQL.columnGram] ?? 0,
        purchasedDate: map[SQL.columnPurchasedDay] ?? "0000-00-00",
        expiredDate: map[SQL.columnExpiredDay] ?? "0000-00-00");
  }
}
