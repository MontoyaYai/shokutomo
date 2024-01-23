import 'package:firebase_auth/firebase_auth.dart';
import 'package:shokutomo/firebase/categories_json_map.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shokutomo/firebase/recipe_json_map.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';

import 'myrecipe_json_map.dart';
//

class FirebaseServices {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Formate Date for Firebase (String "0000-00-00")
  String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  //!! GET METHOD !!\\

//Get Categorys and returns name, image, and category no
  Future<List<Categories>> getUniqueCategories() async {
    CollectionReference collectionReferenceProduct =
        database.collection('products');
    Map<String, Map<String, dynamic>> categoryData = {};
    try {
      QuerySnapshot querySnapshot = await collectionReferenceProduct.get();
      for (var document in querySnapshot.docs) {
        Map<String, dynamic> productData =
            document.data() as Map<String, dynamic>;
        String category = productData["product_category"];
        int categoryNo = productData["category_no"];
        String image = productData["image"];
        if (!categoryData.containsKey(category)) {
          categoryData[category] = {
            "category_no": categoryNo,
            "image": image,
            "product_category": category,
          };
        }
      }
      List<Categories> categories = categoryData.values.map((categoryMap) {
        return Categories.fromMap(categoryMap);
      }).toList();
      return categories;
    } catch (error) {
      print("Error in get categories: $error");
      return [];
    }
  }

// Get all the data from PRODUCT
  Future<List<Product>> getFirebaseProducts() async {
    List<Product> products = [];

    CollectionReference collectionReferenceProduct =
        database.collection('products');
    QuerySnapshot queryTest = await collectionReferenceProduct.get();
    for (var document in queryTest.docs) {
      Map<String, dynamic> productData =
          document.data() as Map<String, dynamic>;
      Product product = Product.fromMap(productData);
      products.add(product);
    }
    return products;
  }

// Get a specific PRODUCT by productNo
  Future<Product> getProductByProductNo(String productNo) async {
    CollectionReference collectionReferenceProduct =
        database.collection('products');
    QuerySnapshot querySnapshot = await collectionReferenceProduct
        .where('product_no', isEqualTo: productNo)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      return Product.fromMap(document.data() as Map<String, dynamic>);
    } else {
      throw Exception("Product not found");
    }
  }

// Get all MYPRODUCT
  Future<List<MyProducts>> getFirebaseMyProducts() async {
    List<MyProducts> myProducts = [];

    CollectionReference collectionReferenceMyProducts =
        database.collection('users/${getLoggedInUser()}/myproducts');
    QuerySnapshot query = await collectionReferenceMyProducts.get();
    for (var document in query.docs) {
      Map<String, dynamic> myProductData =
          document.data() as Map<String, dynamic>;
      MyProducts myProduct = MyProducts.fromMap(myProductData);
      myProducts.add(myProduct);
    }
    return myProducts;
  }

// Get all SHOPLIST
  Future<List<ShopList>> getAllShoppingList() async {
    CollectionReference collectionReferenceShopList =
        database.collection('users/${getLoggedInUser()}/shoplist');
    QuerySnapshot querySnapshot = await collectionReferenceShopList.get();

    List<ShopList> shoppingList = querySnapshot.docs
        .map((document) =>
            ShopList.fromMap(document.data() as Map<String, dynamic>))
        .toList();

    return shoppingList;
  }

// Get bought product from SHOPLIST
  Future<List<ShopList>> getBoughtProduct() async {
    CollectionReference collectionReferenceShopList =
        database.collection('users/${getLoggedInUser()}/shoplist');
    QuerySnapshot querySnapshot =
        await collectionReferenceShopList.where('status', isEqualTo: 1).get();

    return querySnapshot.docs
        .map((document) =>
            ShopList.fromMap(document.data() as Map<String, dynamic>))
        .toList();
  }

//Get Recipes
  Future<List<Recipe>> getAllRecipe() async {
    CollectionReference collectionReferenceRecipe =
        database.collection('recipes');
    QuerySnapshot querySnapshot = await collectionReferenceRecipe.get();

    List<Recipe> recipes = querySnapshot.docs
        .map((document) =>
            Recipe.fromMap(document.data() as Map<String, dynamic>))
        .toList();
    return recipes;
  }

  //Get MyRecipe
  Future<List<MyRecipe>> getAllMyRecipe() async {
    CollectionReference collectionReferenceMyRecipe =
        database.collection('users/${getLoggedInUser()}/myrecipe');
    QuerySnapshot querySnapshot = await collectionReferenceMyRecipe.get();

    List<MyRecipe> recipes = querySnapshot.docs
        .map((document) =>
            MyRecipe.fromMap(document.data() as Map<String, dynamic>))
        .toList();
    return recipes;
  }

//?? Get THEMECOLOR ??\\
  Future<int> getThemeColor() async {
    // final DocumentReference userDocRef =
    //     database.doc('users/${getLoggedInUser()}/userinformation');

    // final userData = await userDocRef.get();
    // if (userData.exists) {
    //   final settings = userData.data();
    //   if (settings != null && settings is Map<String, dynamic>) {
    //     final themeColor = settings['settings']['themecolor'];
    //     if (themeColor is int) {
    //       return themeColor;
    //     }
    //   }
    // }
    return 0;
  }

//?? Get SCREEN MODE ??\\
  Future<int> getScreenMode() async {
    final DocumentReference userDocRef =
        database.doc('users/${getLoggedInUser()}/userinformation');

    final userData = await userDocRef.get();
    if (userData.exists) {
      final settings = userData.data();
      if (settings != null && settings is Map<String, dynamic>) {
        final screenMode = settings['settings']['screen_mode'];
        if (screenMode is int) {
          return screenMode;
        }
      }
    }
    return 0;
  }

//!! ADD, UPDATE, or INSERT METHOD !!\\

// Add or Update myProduct
  Future<void> addOrUpdateProductInMyProduct(MyProducts product) async {
    final productNo = product.no;
    final expiredDate = product.expiredDate;

    final myProductCollection =
        database.collection('users/${getLoggedInUser()}/myproducts/');

    final productQuery = await myProductCollection
        .where('product_no', isEqualTo: productNo)
        .where('expired_date', isEqualTo: formatDate(expiredDate))
        .get();

    if (productQuery.docs.isNotEmpty) {
      // Existen productos con el mismo productNo y la misma expiredDate, actualiza
      await Future.forEach(productQuery.docs, (existingProductDoc) async {
        final existingQuantity = existingProductDoc['quantity'] ?? 0;
        final existingGram = existingProductDoc['gram'] ?? 0;

        await existingProductDoc.reference.update({
          'quantity': existingQuantity + product.quantity,
          'gram': existingGram + product.gram,
        });
      });
    } else {
      // El producto no existe, agrégalo como un nuevo documento
      await myProductCollection.add(product.toMap());
    }
  }

// Add or Update SHOPLIST
  Future<void> addOrUpdateProductInShopList(ShopList product) async {
    final CollectionReference shopListCollection =
        database.collection('users/${getLoggedInUser()}/shoplist');

    final QuerySnapshot query = await shopListCollection
        .where('product_no', isEqualTo: product.productNo)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot productDocument = query.docs.first;

      await shopListCollection.doc(productDocument.id).update({
        'quantity': product.quantity,
        'gram': product.gram,
      });
    } else {
      await shopListCollection.add(product.toMap());
    }
  }

//!!Add or Update MyRecipe
  Future<void> addOrUpdateMyRecipe(MyRecipe myRecipe) async {
    final CollectionReference myRecipesCollection =
        database.collection('users/${getLoggedInUser()}/myrecipe');

    final QuerySnapshot query = await myRecipesCollection
        .where('recipe_no', isEqualTo: myRecipe.recipeNo)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot recipeDocument = query.docs.first;

      await myRecipesCollection.doc(recipeDocument.id).update({
        'recipe_name': myRecipe.recipeName,
        'how_to': myRecipe.howTo,
        'cook_time': myRecipe.cookTime,
        'difficult': myRecipe.difficult,
        'quantity': myRecipe.quantity,
        'recipe_category': myRecipe.recipeCategory,
        'image': myRecipe.image,
        'favorite_status': myRecipe.favoriteStatus,
        'ingredients': myRecipe.ingredients
            .map((ingredient) => ingredient.toMap())
            .toList(),
      });
    } else {
      await myRecipesCollection.add(myRecipe.toMap());
    }
  }

// Update record of MYPRODUCT
  Future<int> updateRecordMyProduct(
      MyProducts product, DateTime oldExpiredDate) async {
    final CollectionReference myProductsCollection =
        database.collection('users/${getLoggedInUser()}/myproducts/');

    final QuerySnapshot query = await myProductsCollection
        .where('product_no', isEqualTo: product.no)
        .where('expired_date', isEqualTo: formatDate(oldExpiredDate))
        .get();

    int updatedCount = 0;

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot productDocument = query.docs.first;

      await myProductsCollection.doc(productDocument.id).update({
        'quantity': product.quantity,
        'gram': product.gram,
        'purchased_date': formatDate(product.purchasedDate),
        'expired_date': formatDate(product.expiredDate),
      });

      updatedCount = 1;
    }

    return updatedCount;
  }

// Update status of SHOPLIST
  Future<void> updateStatusOfShopList(String productNo) async {
    final CollectionReference shopListCollection =
        database.collection('users/${getLoggedInUser()}/shoplist');

    final QuerySnapshot query = await shopListCollection
        .where('product_no', isEqualTo: productNo)
        .get();

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot productDocument = query.docs.first;

      final int currentStatus = productDocument.get('status') ?? 0;
      final int newStatus = (currentStatus == 0) ? 1 : 0;

      await shopListCollection.doc(productDocument.id).update({
        'status': newStatus,
      });
    }
  }

// Update THEMECOLOR for settings
  Future<void> updateThemeColor(int selectedColor) async {
    final DocumentReference userDocRef =
        database.doc('users/${getLoggedInUser()}/userinformation');
    await userDocRef.set({
      'settings': {
        'themecolor': selectedColor,
      }
    }, SetOptions(merge: true));
  }

// Insert MYPRODUCT from SHOPLIST
  Future<void> insertMyProductFromShopList() async {
    List<ShopList> insertValues = await FirebaseServices().getBoughtProduct();
    DateTime purchaseDate = DateTime.now();

    for (var value in insertValues) {
      String productNo = value.productNo;
      Product product =
          await FirebaseServices().getProductByProductNo(productNo);

      int daysToExpire = product.categoryBestBy;
      DateTime expiredDate = purchaseDate.add(Duration(days: daysToExpire));

      CollectionReference myProductsCollection =
          database.collection('users/${getLoggedInUser()}/myproducts');

      final productQuery = await myProductsCollection
          .where('product_no', isEqualTo: productNo)
          .where('expired_date', isEqualTo: formatDate(expiredDate))
          .get();

      if (productQuery.docs.isNotEmpty) {
        await Future.forEach(productQuery.docs, (existingProductDoc) async {
          final existingQuantity = existingProductDoc['quantity'] ?? 0;
          final existingGram = existingProductDoc['gram'] ?? 0;

          await existingProductDoc.reference.update({
            'quantity': existingQuantity + value.quantity,
            'gram': existingGram + value.gram,
          });
        });
      } else {
        // Adds the product 'myproducts' in Firebase Firestore
        await myProductsCollection.add({
          'product_no': value.productNo,
          'product_name': product.productName,
          'image': product.image,
          'quantity': value.quantity,
          'gram': value.gram,
          'purchased_date': formatDate(purchaseDate),
          'expired_date': formatDate(expiredDate),
        });
      }
      //Delete the producto from 'shoplist' in Firebase Firestore
      CollectionReference shopListCollection =
          database.collection('users/${getLoggedInUser()}/shoplist');
      QuerySnapshot querySnapshot = await shopListCollection
          .where('product_no', isEqualTo: value.productNo)
          .get();
      for (var doc in querySnapshot.docs) {
        await shopListCollection.doc(doc.id).delete();
      }
    }
  }

//!! DELETE METHOD !!\\

//  Delete from MYPRODUCT
  Future<int> deleteMyProduct(String productNo, DateTime expiredDate) async {
    final userDocRef = database
        .collection('users')
        .doc(getLoggedInUser())
        .collection('myproducts');

    final QuerySnapshot productSnapshot = await userDocRef
        .where(
          'product_no',
          isEqualTo: productNo,
        )
        .where(
          'expired_date',
          isEqualTo: formatDate(expiredDate),
        )
        .get();

    final List<QueryDocumentSnapshot> products = productSnapshot.docs;
    if (products.isNotEmpty) {
      final productToDelete = products.first;
      print('Document Path: ${productToDelete.reference.path}');
      try {
        final DocumentSnapshot productDoc =
            await productToDelete.reference.get(); // ドキュメントを削除する前にゲットします
        if (productDoc.exists) {
          await productToDelete.reference.delete();
          return 1;
        } else {
          print('ドキュメントを見つかりませんでした');
          return 0;
        }
      } catch (e) {
        print('エラー発生しました: $e');
        return 0;
      }
    } else {
      print('削除するitemがありません');
      return 0;
    }
  }

// Delete from SHOPLIST
  Future<void> deleteShopListProduct(String productNo) async {
    CollectionReference shopListCollection =
        database.collection('users/${getLoggedInUser()}/shoplist');

    try {
      final QuerySnapshot querySnapshot = await shopListCollection
          .where('product_no', isEqualTo: productNo)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await shopListCollection.doc(doc.id).delete();
      }
    } catch (error) {
      print("Error deleting shop list product: $error");
    }
  }

  Future<void> deleteMyRecipe(String recipeNo) async {
    CollectionReference myRecipeCollection =
        database.collection('users/${getLoggedInUser()}/myrecipe');

    try {
      final QuerySnapshot querySnapshot = await myRecipeCollection
          .where('recipe_no', isEqualTo: recipeNo)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await myRecipeCollection.doc(doc.id).delete();
      }
    } catch (error) {
      print("Error deleting myRecipe product: $error");
    }
  }

//??
//!! FIREBASE AUTH !! \\
//??
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Check if the user with the given email already exists
      if (await isEmailRegistered(email)) {
        throw 'Email already registered';
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      print('User UID: $uid');

      // Create the user document in the 'users' collection
      await database
          .collection('users')
          .doc(uid)
          .collection('userinfotmation')
          .add({
        'username': username,
        'email': email,
        'password': password,
        // Add more fields if needed
      });
    } on FirebaseAuthException catch (e) {
      print('Error de autenticación: $e');
      throw e.message ?? 'Error de autenticación';
    } catch (e) {
      print('Error desconocido: $e');
      throw 'Error desconocido: $e';
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    // Check if a user with the given email already exists
    var snapshot = await database.collection('users').doc(email).get();
    return snapshot.exists;
  }

//??ここまで

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error de inicio de sesión: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  String getLoggedInUser() {
    User? u = auth.currentUser;

    if (u == null) {
      // ログインしていない場合
      return 'mecha';
    }

    if (u.uid == 'zaumzzH9A4cnkthFNDNiTjY7Jzw1') {
      return 'mecha';
    } else {
      return u.email ?? 'mecha'; // メールが存在しない場合も'mecha'を返す
    }
  }
}
