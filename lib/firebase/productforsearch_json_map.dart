class ProductsForSearch {
  String productNo;
  int categoryNo;
  String productName;
  String productImage;

  ProductsForSearch({
    required this.productNo,
    required this.categoryNo,
    required this.productName,
    required this.productImage,
  });

  factory ProductsForSearch.fromMap(Map<String, dynamic> map) {
    return ProductsForSearch(
      productNo: map['product_no'],
      categoryNo: map['category_no'],
      productName: map['product_name'],
      productImage: map['product_image'] ?? "assets/img/LOGO_BLUE.png",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_no': productNo,
      'category_no': categoryNo,
      'product_name': productName,
      'product_image': productImage,
    };
  }
}
