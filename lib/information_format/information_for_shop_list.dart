import 'package:shokutomo/database/sql.dart';


class InformationForShopList {
  int no;
  String name;
  int quantity;
  int gram;
  String image;
  int status;

  static const selectSQL = '''
    SELECT 
      SL.${SQL.columnProductNo},
      P.${SQL.columnProductName},
      SL.${SQL.columnQuantity},
      SL.${SQL.columnGram},
      P.${SQL.columnProductImage},
      SL.${SQL.columnStatus}
    FROM ${SQL.tableShopList} AS SL 
    JOIN ${SQL.tableProduct} AS P 
    ON SL.${SQL.columnProductNo} = P.${SQL.columnProductNo}
  ''';

  InformationForShopList(
      {required this.no,
      required this.name,
      required this.quantity,
      required this.gram,
      required this.image,
      required this.status});

  factory InformationForShopList.fromMap(Map<String, dynamic> map) {
    return InformationForShopList(
        no: map[SQL.columnProductNo],
        name: map[SQL.columnProductName],
        quantity: map[SQL.columnQuantity],
        gram: map[SQL.columnGram],
        image: map[SQL.columnProductImage],
        status: map[SQL.columnStatus]);
  }
}
