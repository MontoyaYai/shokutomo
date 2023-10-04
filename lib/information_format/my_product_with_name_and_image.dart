import 'package:shokutomo/database/sql.dart';

class MyProductWithNameAndImage {
  int no;
  String name;
  int quantity;
  int gram;
  String image;
  DateTime expiredDate;
  DateTime purchasedDate;

  static const selectSQL = '''
    SELECT 
      P.${SQL.columnProductNo}, 
      P.${SQL.columnProductName}, 
      MP.${SQL.columnQuantity}, 
      MP.${SQL.columnGram}, 
      P.${SQL.columnProductImage}, 
      MP.${SQL.columnExpiredDay},
      MP.${SQL.columnPurchasedDay}
    FROM ${SQL.tableMyProduct} AS MP 
    JOIN ${SQL.tableProduct} AS P 
    ON MP.${SQL.columnProductNo} 
       = P.${SQL.columnProductNo} 
    ORDER BY ${SQL.columnExpiredDay} 
  ''';

  MyProductWithNameAndImage(
      {required this.no,
      required this.name,
      required this.quantity,
      required this.gram,
      required this.image,
      required this.expiredDate,
      required this.purchasedDate});

  factory MyProductWithNameAndImage.fromMap(Map<String, dynamic> map) {
    return MyProductWithNameAndImage(
        no: map[SQL.columnProductNo] ?? 0,
        name: map[SQL.columnProductName],
        quantity: map[SQL.columnQuantity] ?? 0,
        gram: map[SQL.columnGram] ?? 0,
        image: map[SQL.columnProductImage],
        expiredDate: DateTime.parse(map[SQL.columnExpiredDay]),
        purchasedDate: DateTime.parse(map[SQL.columnPurchasedDay]));
  }
}
