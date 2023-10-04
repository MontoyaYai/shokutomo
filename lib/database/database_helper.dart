import 'dart:async';

import 'package:shokutomo/database/app_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shokutomo/database/sql.dart';
import 'package:shokutomo/information_format/categories.dart';
import 'package:shokutomo/information_format/product_table.dart';

class DBHelper {
  static const _dbName = 'shokutomo.db';
  static const _dbVersion = 23;

  final SQL sql = SQL();

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);

    // Delete the entire database
    // Use with caution
    // await deleteDatabase(path);

    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // Create tables for each entity
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(sql.createCategory);
    await db.execute(sql.createProduct);
    await db.execute(sql.createMyProduct);
    await db.execute(sql.createShopList);
    await db.execute(sql.createUserSetting);
    await insert(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion <= newVersion) {
      await db.execute('DROP TABLE IF EXISTS ${SQL.tableCategory}');
      await db.execute('DROP TABLE IF EXISTS ${SQL.tableProduct}');
      await db.execute('DROP TABLE IF EXISTS ${SQL.tableMyProduct}');
      await db.execute('DROP TABLE IF EXISTS ${SQL.tableShopList}');
      await db.execute("DROP TABLE IF EXISTS ${SQL.tableUserSetting}");
      await _onCreate(db, newVersion);
    }
  }

  // Insert initial values into each table
  Future<void> insert(Database db) async {
    //***********
    // Clear table data (not using TABLE DROP)
    // await clearTable();
    //************

    List<Categories> categories = DataManagement().getCategories();
    List<Products> products = DataManagement().getProducts();
    for (var category in categories) {
      await db.insert(SQL.tableCategory, category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (var product in products) {
      await db.insert(SQL.tableProduct, product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    await db.delete(SQL.tableCategory);
    await db.delete(SQL.tableProduct);
    await db.delete(SQL.tableMyProduct);
    await db.delete(SQL.tableShopList);
  }
}
