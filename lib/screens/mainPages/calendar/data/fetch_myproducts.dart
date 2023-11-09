import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';

class FetchMyProductsFromDatabase {
  Map<DateTime, List<MyProducts>> products = {};

  FetchMyProductsFromDatabase() {
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    List<MyProducts> myProducts =
        await FirebaseServices().getFirebaseMyProducts();
    //DateTimeごとに商品を分ける
    for (MyProducts product in myProducts) {
      DateTime expiredDate = product.expiredDate;
      if (products.containsKey(expiredDate)) {
        products[expiredDate]!.add(product);
      } else {
        products[expiredDate] = [product];
      }
    }
  }

  Map<DateTime, List<MyProducts>> getProducts() {
    return products;
  }
}
