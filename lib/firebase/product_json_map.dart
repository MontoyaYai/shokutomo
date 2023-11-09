class Product{
  final String productNo;
  final String productName;
  final String productCategory;
  final int categoryNo;
  final int categoryBestBy;
  final int categoryUseBy;
  final String image;
  final String hiragana;
  final String katakana;
  final String kanji;
  final String romaji;
  final String english;

  Product({
    required this.productNo,
    required this.productName,
    required this.productCategory,
    required this.categoryNo,
    required this.categoryBestBy,
    required this.categoryUseBy,
    required this.image,
    required this.hiragana,
    required this.katakana,
    required this.kanji,
    required this.romaji,
    required this.english,
  });

  // Método para convertir un objeto Product a un mapa que se puede guardar en Firebase.
  Map<String, dynamic> toMap() {
    return {
      'product_no': productNo,
      'product_name': productNo,
      'product_category': productCategory,
      'category_no': categoryNo,
      'category_best_by': categoryBestBy,
      'category_use_by': categoryUseBy,
      'image': image,
      'hiragana': hiragana,
      'katakana': katakana,
      'kanji': kanji,
      'romaji': romaji,
      'english': english,
    };
  }

  // Método estático para crear un objeto Product a partir de un mapa de Firebase.
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      productNo: map['product_no'],
      productName: map['product_name'],
      productCategory: map['product_category'],
      categoryNo: map['category_no'],
      categoryBestBy: map['category_best_by'],
      categoryUseBy: map['category_use_by'],
      image: map['image'],
      hiragana: map['hiragana'],
      katakana: map['katakana'],
      kanji: map['kanji'],
      romaji: map['romaji'],
      english: map['english'],
    );
  }
}
