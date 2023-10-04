import 'package:sqflite/sqflite.dart';
import 'package:shokutomo/database/database_helper.dart';
import 'package:shokutomo/database/sql.dart';
import 'package:shokutomo/information_format/categories.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';
import 'package:shokutomo/information_format/my_products.dart';
import 'package:shokutomo/information_format/product_table.dart';
import 'package:shokutomo/information_format/shop_list.dart';
import 'package:shokutomo/information_format/product_for_search.dart';
import 'package:shokutomo/information_format/information_for_shop_list.dart';
import 'package:velocity_x/velocity_x.dart';

class GetActivity {
  final _dbHelper = DBHelper.instance;
  //   Future<List<ShopList>> getAllShopList() async {
  //   Database db = await _dbHelper.database;
  //   List<Map<String, dynamic>> maps = await db.query(SQL.tableShopList);
  //   return List.generate(maps.length, (i) {
  //     return ShopList.fromMap(maps[i]);
  //   });
  // }

  // Future<List<Categories>> getAllCategories() async {
  //   Database db = await _dbHelper.database;
  //   List<Map<String, dynamic>> maps = await db.query(SQL.tableCategory);
  //   return List.generate(maps.length, (i) {
  //     return Categories.fromMap(maps[i]);
  //   });
  // }

  // Future<List<MyProducts>> getAllMyProducts() async {
  //   Database db = await _dbHelper.database;
  //   List<Map<String, dynamic>> maps = await db.query(SQL.tableMyProduct);
  //   return List.generate(maps.length, (i) {
  //     return MyProducts.fromMap(maps[i]);
  //   });
  // }

  Future<List<Categories>> getCategories() async {
    final database = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await database.query(SQL.tableCategory);

    return List.generate(maps.length, (index) {
      return Categories.fromMap(maps[index]);
    });
  }

  Future<List<Products>> getAllProducts() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(SQL.tableProduct);
    return List.generate(maps.length, (i) {
      return Products.fromMap(maps[i]);
    });
  }

  Future<List<MyProductWithNameAndImage>> getMyProducts() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps =
        await db.rawQuery(MyProductWithNameAndImage.selectSQL);

    return List.generate(maps.length, (index) {
      return MyProductWithNameAndImage.fromMap(maps[index]);
    });
  }

  Future<List<ShopList>> getAllShoppingList() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(SQL.tableShopList);

    return List.generate(maps.length, (i) {
      return ShopList.fromMap(maps[i]);
    });
  }

  Future<Products> getProductByProductNo(int productNo) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(SQL.tableProduct,
        where: '${SQL.columnProductNo} = ?', whereArgs: [productNo]);

    if (result.isNotEmpty) {
      return Products.fromMap(result.first);
    } else {
      throw Exception("Product not found");
    }
  }

  Future<ShopList?> getShopListProductByNo(int productNo) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      SQL.tableShopList,
      where: '${SQL.columnProductNo} = ?',
      whereArgs: [productNo],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return ShopList.fromMap(result.first);
    }
    return null;
  }

  Future<MyProducts?> getMyProductByNoAndExpiredDate(
      int productNo, String expiredDate) async {
    final db = await _dbHelper.database;

    List<Map<String, dynamic>> result = await db.query(
      SQL.tableMyProduct,
      where: '${SQL.columnProductNo} = ? AND ${SQL.columnExpiredDay} = ?',
      whereArgs: [productNo, expiredDate],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return MyProducts.fromMap(result.first);
    }

    return null;
  }

  Future<List<InformationForShopList>> getBoughtProduct() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> boughtItemList = await db.rawQuery(
        "${InformationForShopList.selectSQL} WHERE ${SQL.columnStatus} = 1");
    return boughtItemList.generate(
        (index) => InformationForShopList.fromMap(boughtItemList[index]));
  }

  Future<int> getThemeColor() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
        'SELECT ${SQL.columnThemeColor} FROM ${SQL.tableUserSetting}');
    if (results.isNotEmpty) {
      int themeColor = results.first[SQL.columnThemeColor];
      return themeColor;
    }
    return 0;
  }

  Future<int> getScreenMode() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT ${SQL.columnScreenMode} FROM ${SQL.tableUserSetting}");
    if (results.isNotEmpty) {
      int screenMode = results.first[SQL.columnScreenMode];
      return screenMode;
    }
    return 0;
  }

  Future<bool> isProductAlreadyExistInMyProduct(MyProducts product) async {
    final db = await DBHelper.instance.database;
    final productNo = product.productNo;
    final expiredDate = product.expiredDate;

    List<Map<String, dynamic>> result = await db.query(
      SQL.tableMyProduct,
      where: '${SQL.columnProductNo} = ? AND ${SQL.columnExpiredDay} = ?',
      whereArgs: [productNo, expiredDate],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<bool> isProductAlreadyExistInShopList(ShopList product) async {
    final db = await DBHelper.instance.database;
    final productNo = product.productNo;

    List<Map<String, dynamic>> result = await db.query(
      SQL.tableShopList,
      where: '${SQL.columnProductNo} = ?',
      whereArgs: [productNo],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<List<ProductsForSearch>> getSearchResults(
      String searchText, int categoryNo) async {
    DBHelper dbHelper = DBHelper.instance;
    Database db = await dbHelper.database;

    List<Map<String, dynamic>> maps = [];

    //searchText がNULLの場合はSQLを実行せずに返す
    if (searchText.isEmpty) return [];
    //固定フォマードの抽出文
    const searchSQL = '''
      SELECT ${SQL.columnProductNo}, ${SQL.columnCategoryNo}, ${SQL.columnProductName}, ${SQL.columnProductImage} 
      FROM ${SQL.tableProduct} 
      WHERE   ${SQL.columnHiraganna} LIKE(?) OR
              ${SQL.columnKatakana} LIKE(?) OR
              ${SQL.columnKanji} LIKE(?) OR
              ${SQL.columnRomaji} LIKE(?) OR
              ${SQL.columnEnglish} LIKE(?);
    ''';

    const searchSQLWithCategoryNo = '''
      SELECT ${SQL.columnProductNo}, ${SQL.columnCategoryNo}, ${SQL.columnProductName}, ${SQL.columnProductImage} 
      FROM ${SQL.tableProduct}
      WHERE   ${SQL.columnHiraganna} LIKE(?) OR
              ${SQL.columnKatakana} LIKE(?) OR
              ${SQL.columnKanji} LIKE(?) OR
              ${SQL.columnRomaji} LIKE(?) OR
              ${SQL.columnEnglish} LIKE(?) AND
              ${SQL.columnCategoryNo} == ?;
    ''';
    // SELECT文実行
    if (categoryNo != 0) {
      maps = await db.rawQuery(searchSQLWithCategoryNo, [
        '%$searchText%',
        '%$searchText%',
        '%$searchText%',
        '%$searchText%',
        '%$searchText%',
        categoryNo
      ]);
    } else {
      maps = await db.rawQuery(searchSQL, [
        '%$searchText%',
        '%$searchText%',
        '%$searchText%',
        '%$searchText%',
        '%$searchText%',
      ]);
    }

    return List.generate(maps.length, (index) {
      return ProductsForSearch.fromMap(maps[index]);
    });
  }

  Future<int> getUseByOrBestBy(int productNo) async {
    final db = await _dbHelper.database;

    List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT ${SQL.columnUseBy}, ${SQL.columnBestBy}
      FROM ${SQL.tableProduct}
      WHERE ${SQL.columnProductNo} = $productNo
    ''');
    return results.first[SQL.columnBestBy];
  }
}
