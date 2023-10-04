import 'package:shokutomo/database/sql.dart';

class ProductsForSearch {
  int productNo;
  int categoryNo;
  String productName;
  String productImage;

  ProductsForSearch(
      {required this.productNo,
      required this.categoryNo,
      required this.productName,
      required this.productImage});

  factory ProductsForSearch.fromMap(Map<String, dynamic> map) {
    return ProductsForSearch(
        productNo: map[SQL.columnProductNo],
        categoryNo: map[SQL.columnCategoryNo],
        productName: map[SQL.columnProductName],
        productImage:
            map[SQL.columnProductImage] ?? "assets/img/LOGO_BLUE.png");
  }

  Map<String, dynamic> toMap() {
    return {
      SQL.columnProductNo: productNo,
      SQL.columnCategoryNo: categoryNo,
      SQL.columnProductName: productName,
      SQL.columnProductImage: productImage
    };
  }
}
