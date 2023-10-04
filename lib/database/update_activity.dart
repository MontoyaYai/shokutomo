import 'package:shokutomo/database/database_helper.dart';
import 'package:shokutomo/database/get_activity.dart';
import 'package:shokutomo/database/sql.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';
import 'package:shokutomo/information_format/shop_list.dart';

class UpdateActivity {
  final _dbHelper = DBHelper.instance;
  Future<void> updateProduct(Map<String, dynamic> updatedProduct) async {
    final db = await _dbHelper.database;
    final productNo = updatedProduct[SQL.columnProductNo];
    final expiredDate = updatedProduct[SQL.columnExpiredDay];
    final existingProduct = await GetActivity()
        .getMyProductByNoAndExpiredDate(productNo, expiredDate);
    if (existingProduct != null) {
      final int existingQuantity = existingProduct.quantity;
      final int existingGram = existingProduct.gram;
      final int updatedQuantity = updatedProduct[SQL.columnQuantity] ?? 0;
      final int updatedGram = updatedProduct[SQL.columnGram] ?? 0;
      updatedProduct[SQL.columnQuantity] = existingQuantity + updatedQuantity;
      updatedProduct[SQL.columnGram] = existingGram + updatedGram;
      await db.update(
        SQL.tableMyProduct,
        updatedProduct,
        where: '${SQL.columnProductNo} = ? AND ${SQL.columnExpiredDay} = ?',
        whereArgs: [productNo, expiredDate],
      );
    }
  }

  Future<void> updateShopList(Map<String, dynamic> updatedProduct) async {
    final db = await _dbHelper.database;
    final productNo = updatedProduct[SQL.columnProductNo];
    final existingProduct =
        await GetActivity().getShopListProductByNo(productNo);

    if (existingProduct != null) {
      final int existingQuantity = existingProduct.quantity;
      final int existingGram = existingProduct.gram;

      final int updatedQuantity = updatedProduct[SQL.columnQuantity] ?? 0;
      final int updatedGram = updatedProduct[SQL.columnGram] ?? 0;

      updatedProduct[SQL.columnQuantity] = existingQuantity + updatedQuantity;
      updatedProduct[SQL.columnGram] = existingGram + updatedGram;

      await db.update(
        SQL.tableShopList,
        updatedProduct,
        where: '${SQL.columnProductNo} = ?',
        whereArgs: [productNo],
      );
    }
  }

  Future updateThemeColor(int selectedColor) async {
    final db = await _dbHelper.database;
    //THEME_COLOR columnに
    //◆データが存在の場合　=>　データを上書きする
    //◆データがない場合　=>　新規保存する

    //ThemeColorのデータを取得してみる
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT ${SQL.columnThemeColor} FROM ${SQL.tableUserSetting}',
    );
    //データがあるかどうか判定する
    bool hasData =
        results.isNotEmpty && results.first[SQL.columnThemeColor] != null;

    if (hasData) {
      // データが存在, UPDATE
      String updateSQL = '''
        UPDATE ${SQL.tableUserSetting} 
        SET ${SQL.columnThemeColor} = $selectedColor;
      ''';
      await db.rawUpdate(updateSQL);
    } else {
      // データがない, INSERT
      String insertSQL = '''
        INSERT INTO ${SQL.tableUserSetting} (${SQL.columnThemeColor})
        VALUES ($selectedColor);
      ''';
      await db.rawInsert(insertSQL);
    }
  }

  //Update Status of ShopList
  //購入済チェックした時、使われる
  Future updateStatusOfShopList(int productNo) async {
    final db = await _dbHelper.database;
    String updateSQL = '''
      UPDATE ${SQL.tableShopList} 
      SET ${SQL.columnStatus} = CASE 
        WHEN ${SQL.columnStatus} = 0 THEN 1 
        ELSE 0 END
      WHERE ${SQL.columnProductNo} = $productNo ;
    ''';

    await db.rawUpdate(updateSQL);
  }

  //Update MyProduct table
  Future<int> updateRecord(
      MyProductWithNameAndImage product, DateTime oldExpiredDate) async {
    final db = await _dbHelper.database;
    String updateSQL = '''
      UPDATE ${SQL.tableMyProduct} 
      SET ${SQL.columnQuantity} = ${product.quantity},
          ${SQL.columnGram} = ${product.gram},
          ${SQL.columnPurchasedDay} = "${product.purchasedDate}",
          ${SQL.columnExpiredDay} = "${product.expiredDate}" 
      WHERE ${SQL.columnProductNo} = ${product.no} AND
            ${SQL.columnExpiredDay} = "$oldExpiredDate" ;
    ''';

    int count = await db.rawUpdate(updateSQL);
    return count;
  }

  Future<void> updateProductOfShopList(ShopList product) async {
    final db = await _dbHelper.database;

    String updateSQL = '''
      UPDATE ${SQL.tableShopList} 
      SET ${SQL.columnQuantity} = ${product.quantity},
          ${SQL.columnGram} = ${product.gram} 
      WHERE ${SQL.columnProductNo} = ${product.productNo} ;
    ''';
    //update文実行
    await db.rawUpdate(updateSQL);
  }

  Future UpdateQuantityAndGramOfMyProduct(
      int no, DateTime expiredDate, int quantity, num gram) async {
    final db = await _dbHelper.database;
    await db.rawUpdate('''
        UPDATE ${SQL.tableMyProduct}
        SET ${SQL.columnQuantity} = $quantity,
            ${SQL.columnGram} = $gram
        WHERE ${SQL.columnProductNo} = $no 
          AND ${SQL.columnExpiredDay} = "$expiredDate" 
      ''');
  }
}
