import 'package:shokutomo/database/sql.dart';

class Categories {
  int no;
  String name;
  String image;

  Categories({required this.no, required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      SQL.columnCategoryNo: no,
      SQL.columnCategoryName: name,
      SQL.columnCategoryImage: image
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
        no: map[SQL.columnCategoryNo],
        name: map[SQL.columnCategoryName],
        image: map[SQL.columnCategoryImage]);
  }
}
