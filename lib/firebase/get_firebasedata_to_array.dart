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

  
  Future<List<Product>> productsArray() async => await products;
  Future<List<MyProducts>> myProductsArray() async => await myProducts;
  Future<List<Categories>> categoriesArray() async => await categories;
  Future<List<ShopList>>  shoppingListArray() async => await shoppingList;


Future<List<Product>> searchProductsInArray(String searchText) async {
  final productsArray = await products;
  //searchText がNULLの場合は検索せずに空のリストを返す
  if (searchText.isEmpty) return [];

  // Realizar la búsqueda en el array local
  return productsArray.where((product) =>
      product.hiragana.toLowerCase().contains(searchText.toLowerCase()) ||
      product.katakana.toLowerCase().contains(searchText.toLowerCase()) ||
      product.kanji.toLowerCase().contains(searchText.toLowerCase()) ||
      product.romaji.toLowerCase().contains(searchText.toLowerCase()) ||
      product.english.toLowerCase().contains(searchText.toLowerCase()))
    .toList();
}


}
