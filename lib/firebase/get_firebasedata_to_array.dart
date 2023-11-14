// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shokutomo/firebase/categories_json_map.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';

class GetFirebaseDataToArray {
  late Future<List<Product>> products;
  late Future<List<Categories>> categories;
  late Future<List<MyProducts>> myProducts;
  late Future<List<ShopList>> shoppingList;

  final FirebaseServices firebaseServices = FirebaseServices();

  GetFirebaseDataToArray() {
    getFirebase();
  }

   getFirebase() async{
    final firebaseProducts = firebaseServices.getFirebaseProducts();
    final firebaseCategories = firebaseServices.getUniqueCategories();
    final firebaseMyproduct = firebaseServices.getFirebaseMyProducts();
    final firebaseShoppingList = firebaseServices.getAllShoppingList();

    products = firebaseProducts ;
    categories = firebaseCategories ;
    myProducts = firebaseMyproduct ;
    shoppingList = firebaseShoppingList ;
  }

  
  Future<List<Product>> productsArray() => products;

  Future<List<MyProducts>> myProductsArray() => myProducts;

  Future<List<Categories>> categoriesArray() => categories;

}
