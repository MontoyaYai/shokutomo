import 'package:sqflite/sqflite.dart';
import 'package:shokutomo/database/database_helper.dart';
import 'package:shokutomo/database/get_activity.dart';
import 'package:shokutomo/database/sql.dart';
import 'package:shokutomo/database/update_activity.dart';
import 'package:shokutomo/information_format/my_products.dart';
import 'package:shokutomo/information_format/product_table.dart';
import 'package:shokutomo/information_format/information_for_shop_list.dart';
import 'package:shokutomo/information_format/shop_list.dart';

class InsertActivity {
  final _dbHelper = DBHelper.instance;
  Future<int> insertMyProduct(Map<String, dynamic> productMap) async {
    final db = await _dbHelper.database;
    return await db.insert(
      SQL.tableMyProduct,
      productMap,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> insertShopList(Map<String, dynamic> productMap) async {
    final db = await _dbHelper.database;
    return await db.insert(
      SQL.tableShopList,
      productMap,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future insertMyProductFromShopList() async {
    final db = await _dbHelper.database;
    List<InformationForShopList> insertValues =
        await GetActivity().getBoughtProduct();
    DateTime purchaseDate = DateTime.now();

    for (var value in insertValues) {
      int productNo = value.no;
      Products product = await GetActivity().getProductByProductNo(productNo);

      int daysToExpire = product.bestBy;
      DateTime expiredDate = purchaseDate.add(Duration(days: daysToExpire));
      await db.insert(
        SQL.tableMyProduct,
        {
          SQL.columnProductNo: value.no,
          SQL.columnQuantity: value.quantity,
          SQL.columnGram: value.gram,
          SQL.columnPurchasedDay:
              DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day)
                  .toString(),
          SQL.columnExpiredDay:
              DateTime(expiredDate.year, expiredDate.month, expiredDate.day)
                  .toString(),
        },
      );
      await db.rawDelete(
          "DELETE FROM ${SQL.tableShopList} WHERE ${SQL.columnProductNo} = $productNo");
    }
  }

  Future<void> insertOrUpdateProducts(MyProducts product) async {
    if (await GetActivity().isProductAlreadyExistInMyProduct(product)) {
      await UpdateActivity().updateProduct(product.toMap());
    } else {
      await InsertActivity().insertMyProduct(product.toMap());
    }
  }

  Future<void> insertOrUpdateIntoShopList(ShopList product) async {
    if (await GetActivity().isProductAlreadyExistInShopList(product)) {
      await UpdateActivity().updateShopList(product.toMap());
    } else {
      await InsertActivity().insertShopList(product.toMap());
    }
  }
}
