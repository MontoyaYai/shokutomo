import 'package:shokutomo/database/get_activity.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';

class FetchMyProductsFromDatabase {
  Map<DateTime, List<MyProductWithNameAndImage>> products = {};

  FetchMyProductsFromDatabase() {
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    List<MyProductWithNameAndImage> myProducts =
        await GetActivity().getMyProducts();
    //DateTimeごとに商品を分ける
    for (MyProductWithNameAndImage product in myProducts) {
      DateTime expiredDate = product.expiredDate;
      if (products.containsKey(expiredDate)) {
        products[expiredDate]!.add(product);
      } else {
        products[expiredDate] = [product];
      }
    }
  }

  Map<DateTime, List<MyProductWithNameAndImage>> getProducts() {
    return products;
  }
}
