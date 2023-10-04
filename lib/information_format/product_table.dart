import 'package:shokutomo/database/sql.dart';

class Products {
  int categoryNo;
  int no;
  String name;
  int bestBy;
  int useBy;
  String image;
  String hiragana;
  String katakana;
  String kanji;
  String romaji;
  String english;

  Products({
    required this.categoryNo,
    required this.no,
    required this.name,
    required this.bestBy,
    required this.useBy,
    required this.image,
    required this.hiragana,
    required this.katakana,
    required this.kanji,
    required this.romaji,
    required this.english
  });

  Map<String, dynamic> toMap() {
    return {
      SQL.columnCategoryNo: categoryNo,
      SQL.columnProductNo: no,
      SQL.columnProductName: name,
      SQL.columnBestBy: bestBy,
      SQL.columnUseBy: useBy,
      SQL.columnProductImage: image,
      SQL.columnHiraganna: hiragana,
      SQL.columnKatakana: katakana,
      SQL.columnKanji: kanji,
      SQL.columnRomaji: romaji,
      SQL.columnEnglish: english
    };
  }

  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
        categoryNo: map[SQL.columnCategoryNo],
        no: map[SQL.columnProductNo],
        name: map[SQL.columnProductName],
        bestBy: map[SQL.columnBestBy],
        useBy: map[SQL.columnUseBy],
        image: map[SQL.columnProductImage],
        hiragana: map[SQL.columnHiraganna],
        katakana: map[SQL.columnKatakana],
        kanji: map[SQL.columnKanji],
        romaji: map[SQL.columnRomaji],
        english: map[SQL.columnEnglish]);
  }
}
