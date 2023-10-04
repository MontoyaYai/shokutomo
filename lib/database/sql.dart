class SQL {
  static const tableCategory = 'CATEGORY';
  static const columnCategoryNo = 'CATEGORY_NO';
  static const columnCategoryName = 'CATEGORY_NAME';
  static const columnCategoryImage = 'CATEGORY_IMAGE';

  static const tableProduct = 'PRODUCT';
  static const columnProductNo = 'PRODUCT_NO';
  static const columnProductName = 'PRODUCT_NAME';
  static const columnBestBy = 'BEST_BY';
  static const columnUseBy = 'USE_BY';
  static const columnProductImage = 'PRODUCT_IMAGE';
  static const columnHiraganna = 'HIRAGANA';
  static const columnKatakana = 'KATAKANA';
  static const columnKanji = 'KANJI';
  static const columnRomaji = 'ROMAJI';
  static const columnEnglish = 'ENGLISH';

  static const tableMyProduct = 'MYPRODUCT';
  static const columnQuantity = 'QUANTITY';
  static const columnGram = 'GRAM';
  static const columnPurchasedDay = 'PURCHASE_DATE';
  static const columnExpiredDay = 'EXPIRED_DATE';

  static const tableShopList = 'SHOPLIST';
  static const columnStatus = "STATUS";

  static const tableUserSetting = "USERSETTING";
  static const columnUserName = "USER_NAME";
  static const columnFamilySize = "FAMILY_SIZE";
  static const columnEmail = "EMAIL";
  static const columnPassword = "PASSWORD";
  static const columnThemeColor = "THEME_COLOR";
  static const columnScreenMode = "SCREEN_MODE";

  final String createCategory = '''
      CREATE TABLE $tableCategory(
        $columnCategoryNo INT PRIMARY KEY,
        $columnCategoryName TEXT NOT NULL,
        $columnCategoryImage TEXT
      );
  ''';

  final String createProduct = '''
      CREATE TABLE $tableProduct(
        $columnCategoryNo INT NOT NULL,
        $columnProductNo INT PRIMARY KEY,
        $columnProductName TEXT NOT NULL,
        $columnBestBy INT,
        $columnUseBy INT,
        $columnProductImage TEXT,
        $columnHiraganna TEXT,
        $columnKatakana TEXT,
        $columnKanji TEXT,
        $columnRomaji TEXT,
        $columnEnglish TEXT,
        FOREIGN KEY ($columnCategoryNo) REFERENCES $tableCategory($columnCategoryNo)
      );
  ''';

  final String createMyProduct = '''
    CREATE TABLE $tableMyProduct (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnProductNo INT NOT NULL,
      $columnQuantity INT,
      $columnGram INT,
      $columnPurchasedDay TEXT NOT NULL,
      $columnExpiredDay TEXT NOT NULL,
      FOREIGN KEY ($columnProductNo) REFERENCES $tableProduct($columnProductNo)
    );
  ''';

  //status 0: 未購入
  //status 1: 購入済
  final String createShopList = '''
    CREATE TABLE $tableShopList (
      $columnProductNo INT NOT NULL,
      $columnQuantity INT,
      $columnGram INT,
      $columnStatus INT ,
      FOREIGN KEY ($columnProductNo) REFERENCES $tableProduct($columnProductNo)
    );
  ''';

  final String createUserSetting = '''
    CREATE TABLE $tableUserSetting (
      $columnUserName TEXT , 
      $columnFamilySize INT , 
      $columnEmail TEXT ,
      $columnPassword TEXT , 
      $columnThemeColor INT DEFAULT 0,
      $columnScreenMode INT 
    );
  ''';
}
