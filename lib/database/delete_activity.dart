import 'package:shokutomo/database/database_helper.dart';
import 'package:shokutomo/database/sql.dart';

class DeleteActivity {
  final _dbHelper = DBHelper.instance;

  Future<void> deleteShopListProduct(int productNo) async {
    final db = await _dbHelper.database;
    await db.delete(SQL.tableShopList,
        where: '${SQL.columnProductNo} = ?', whereArgs: [productNo]);
  }

  //MyProduct table の商品を削除する
  //calendar_page とinventory_pageに使われる
  Future<int> deleteMyProduct(int productNo, DateTime expiredDate) async {
    final db = await _dbHelper.database;
    String deleteSQL = '''
      DELETE FROM ${SQL.tableMyProduct} 
      WHERE ${SQL.columnProductNo} = $productNo AND 
            ${SQL.columnExpiredDay} = "$expiredDate" ;
    ''';
    int count = await db.rawDelete(deleteSQL);
    return count;
  }

  // Future<void> deleteProduct(int productNo) async {
  //   final db = await _dbHelper.database;

  //   String deleteSQL = '''
  //     DELETE FROM ${SQL.tableShopList} 
  //     WHERE ${SQL.columnProductNo} = $productNo ;
  //   ''';
  //   await db.delete(deleteSQL);
  // }
}
