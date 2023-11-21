import 'package:firebase_auth/firebase_auth.dart';
import 'package:shokutomo/firebase/categories_json_map.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shokutomo/firebase/productforsearch_json_map.dart';
import 'package:shokutomo/firebase/shoplist_json_map.dart';
//

class FirebaseServices {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

//!! GET METHOD's !!\\

// Get PRODUCT
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

// Get PRODUCT by productNo
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


//!!Check
// Get searchproduct from PRODUCT
  Future<List<ProductsForSearch>> getSearchResults(
      String searchText, int productNo) async {
    final productsCollection = database.collection('products');

    QuerySnapshot querySnapshot;

    if (productNo != 0) {
      querySnapshot = await productsCollection
          .where('product_no', isEqualTo: productNo)
          .where('product_name', isGreaterThanOrEqualTo: searchText)
          .where('product_name', isLessThanOrEqualTo: searchText + '\uf8ff')
          .get();
    } else {
      querySnapshot = await productsCollection
          .where('product_name',
              isGreaterThanOrEqualTo: searchText.toLowerCase())
          .where('product_name',
              isLessThanOrEqualTo: searchText.toLowerCase() + '\uf8ff')
          .get();
    }

    final productsList = querySnapshot.docs
        .map((document) =>
            ProductsForSearch.fromMap(document.data() as Map<String, dynamic>))
        .toList();

    return productsList;
  }

// Get Unique CATEGORIES
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

// Get MYPRODUCT
  Future<List<MyProducts>> getFirebaseMyProducts() async {
    List<MyProducts> myProducts = [];

    CollectionReference collectionReferenceMyProducts =
        database.collection('users/mecha/myproducts');
    QuerySnapshot query = await collectionReferenceMyProducts.get();
    for (var document in query.docs) {
      Map<String, dynamic> myProductData =
          document.data() as Map<String, dynamic>;
      MyProducts myProduct = MyProducts.fromMap(myProductData);
      myProducts.add(myProduct);
    }
    return myProducts;
  }

// Get MYPRODUCT by No and Expire date
  Future<MyProducts?> getMyProductByNoAndExpiredDate(
      int productNo, String expiredDate) async {
    CollectionReference collectionReferenceMyProducts =
        database.collection('users/mecha/myproducts');
    QuerySnapshot querySnapshot = await collectionReferenceMyProducts
        .where('productNo', isEqualTo: productNo)
        .where('expiredDate', isEqualTo: expiredDate)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      return MyProducts.fromMap(document.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

// Get Use by or best by from MYPRODUCT
  Future<int> getUseByOrBestBy(String productNo) async {
    final myProductsCollection = database.collection('myproducts');

    final documentSnapshot =
        await myProductsCollection.doc(productNo.toString()).get();
    final data = documentSnapshot.data();

    if (data != null) {
      final bestBy = data['bestBy'] as int;
      return bestBy;
    }
    return 0;
  }

// Get SHOPLIST
  Future<List<ShopList>> getAllShoppingList() async {
    CollectionReference collectionReferenceShopList =
        database.collection('users/mecha/shoplist');
    QuerySnapshot querySnapshot = await collectionReferenceShopList.get();

    List<ShopList> shoppingList = querySnapshot.docs
        .map((document) =>
            ShopList.fromMap(document.data() as Map<String, dynamic>))
        .toList();

    return shoppingList;
  }

// Get SHOPLIST by ProductNo
  Future<ShopList?> getShopListProductByNo(int productNo) async {
    CollectionReference collectionReferenceShopList =
        database.collection('users/mecha/shoplist');
    QuerySnapshot querySnapshot = await collectionReferenceShopList
        .where('productNo', isEqualTo: productNo)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      return ShopList.fromMap(document.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

// Get bought product from SHOPLIST
  Future<List<ShopList>> getBoughtProduct() async {
    CollectionReference collectionReferenceShopList =
        database.collection('users/mecha/shoplist');
    QuerySnapshot querySnapshot =
        await collectionReferenceShopList.where('status', isEqualTo: 1).get();

    return querySnapshot.docs
        .map((document) =>
            ShopList.fromMap(document.data() as Map<String, dynamic>))
        .toList();
  }

// Get THEMECOLOR
  Future<int> getThemeColor() async {
    // final DocumentReference userDocRef =
    //     database.doc('users/mecha/userinformation');

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

// Get SCREEN MODE
  Future<int> getScreenMode() async {
    final DocumentReference userDocRef =
        database.doc('users/mecha/userinformation');

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

//!! CHECK PRODUCT EXISTENCE !!\\

Future<void> addOrUpdateProductInMyProduct(MyProducts product) async {
  final productNo = product.no;
  final expiredDate = product.expiredDate;

  final myProductCollection = database.collection('users/mecha/myproducts/');

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

String formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}



// CHECK product exist in SHOPLIST
  Future<bool> isProductAlreadyExistInShopList(ShopList product) async {
    final productNo = product.productNo;

    final shopListCollection = database.collection('users/mecha/shoplist');

    final querySnapshot = await shopListCollection
        .where('product_no', isEqualTo: productNo)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

//!! ADD METHOD's !!\\

// Add or update firebase PRODUCT
  Future<void> addOrUpdateFirebaseProduct(Product product) async {
    CollectionReference collectionReferenceProduct =
        database.collection('products');

    final existingProduct =
        await collectionReferenceProduct.doc(product.productNo).get();
    if (existingProduct.exists) {
      await collectionReferenceProduct
          .doc(product.productNo)
          .update(product.toMap());
    } else {
      await collectionReferenceProduct.add(product.toMap());
    }
  }

// Add or update firebase MYPRODUCT
  Future<void> addOrUpdateFirebaseMyProduct(MyProducts product) async {
    CollectionReference collectionReferenceProduct =
        database.collection('users/mecha/myproducts');

    final existingProduct =
        await collectionReferenceProduct.doc(product.no).get();
    if (existingProduct.exists) {
      await collectionReferenceProduct.doc(product.no).update(product.toMap());
    } else {
      await collectionReferenceProduct.add(product.toMap());
    }
  }

//!! DELETE METHOD'S !!\\

// Delete from SHOPLIST
  Future<void> deleteShopListProduct(String productNo) async {
    CollectionReference collectionReferenceShopList =
        database.collection('users/mecha/shoplist');

    try {
      await collectionReferenceShopList
          .where('product_no', isEqualTo: productNo)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (error) {
      print("Error deleting shop list product: $error");
    }
  }

// Delete from MYPRODUCT
Future<int> deleteMyProduct(String productNo, DateTime expiredDate) async {
  final userDocRef = database.doc('users/mecha/myproducts');

  final QuerySnapshot productSnapshot = await userDocRef
      .collection('myproducts')
      .where(
        'product_no',
        isEqualTo: productNo,
      )
      .where(
        'expired_date',
        isEqualTo: formatDate(expiredDate),
      )
      .get();

  final List<DocumentSnapshot> products = productSnapshot.docs;

  if (products.isNotEmpty) {
    final productToDelete = products.first;
    await productToDelete.reference.delete();
    return 1;
  } else {
    return 0;
  }
}



//!! UPDATE METHOD's !!\\

// Update MYPRODUCT
  // Future<void> updateMyProduct(Map<String, dynamic> updatedProduct) async {
  //   final int productNo = updatedProduct['productNo'];
  //   final String expiredDate = updatedProduct['expiredDay'];

  //   final QuerySnapshot productSnapshot = await database
  //       .collection('users/mecha/myproducts')
  //       .where('productNo', isEqualTo: productNo)
  //       .where('expiredDay', isEqualTo: expiredDate)
  //       .get();

  //   if (productSnapshot.docs.isNotEmpty) {
  //     final existingProduct =
  //         productSnapshot.docs.first.data() as Map<String, dynamic>;

  //     final int existingQuantity = existingProduct['quantity'] ?? 0;
  //     final int existingGram = existingProduct['gram'] ?? 0;
  //     final int updatedQuantity = updatedProduct['quantity'] ?? 0;
  //     final int updatedGram = updatedProduct['gram'] ?? 0;

  //     final int newQuantity = existingQuantity + updatedQuantity;
  //     final int newGram = existingGram + updatedGram;

  //     await database
  //         .collection('products')
  //         .doc(productSnapshot.docs.first.id)
  //         .update({
  //       'quantity': newQuantity,
  //       'gram': newGram,
  //     });
  //   }
  // }

// Update Quantity and grams from MYPRODUCT
  Future<void> updateQuantityAndGramOfMyProduct(
      String no, DateTime expiredDate, int quantity, num gram) async {
    final CollectionReference myProductsCollection =
        database.collection('/users/mecha/myproducts');

    final QuerySnapshot query = await myProductsCollection
        .where('productNo', isEqualTo: no)
        .where('expiredDate', isEqualTo: expiredDate.toUtc())
        .get();

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot productDocument = query.docs.first;
      final Map<String, dynamic> productData =
          productDocument.data() as Map<String, dynamic>;

      final int existingQuantity = productData['quantity'] ?? 0;
      final num existingGram = productData['gram'] ?? 0;

      final int updatedQuantity = existingQuantity + quantity;
      final num updatedGram = existingGram + gram;

      await myProductsCollection.doc(productDocument.id).update({
        'quantity': updatedQuantity,
        'gram': updatedGram,
      });
    }
  }

// Update record of MYPRODUCT
Future<int> updateRecordMyProduct(
    MyProducts product, DateTime oldExpiredDate) async {
  final CollectionReference myProductsCollection =
      database.collection('users/mecha/myproducts');

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
      'purchased_date': product.purchasedDate.toUtc().toIso8601String(),
      'expired_date': product.expiredDate.toUtc().toIso8601String(),
    });

    updatedCount = 1;
  }

  return updatedCount;
  }



// Update SHOPLIST
  Future<void> updateShopList(Map<String, dynamic> updatedProduct) async {
    final int productNo = updatedProduct['productNo'];

    final DocumentReference productDoc =
        database.collection('/users/mecha/shoplist').doc(productNo.toString());
    final DocumentSnapshot productSnapshot = await productDoc.get();

    if (productSnapshot.exists) {
      final int existingQuantity = productSnapshot['quantity'] ?? 0;
      final int existingGram = productSnapshot['gram'] ?? 0;

      final int updatedQuantity = updatedProduct['quantity'] ?? 0;
      final int updatedGram = updatedProduct['gram'] ?? 0;

      await productDoc.update({
        'quantity': existingQuantity + updatedQuantity,
        'gram': existingGram + updatedGram,
      });
    }
  }

// Update product of SHOPLIST
  Future<void> updateProductOfShopList(ShopList product) async {
    final CollectionReference shopListCollection =
        database.collection('users/mecha/shoplist');

    final QuerySnapshot query = await shopListCollection
        .where('productNo', isEqualTo: product.productNo)
        .get();

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot productDocument = query.docs.first;

      await shopListCollection.doc(productDocument.id).update({
        'quantity': product.quantity,
        'gram': product.gram,
      });
    }
  }

// Update status of SHOPLIST
  Future<void> updateStatusOfShopList(String productNo) async {
    final CollectionReference shopListCollection =
        database.collection('users/mecha/shoplist');

    final QuerySnapshot query =
        await shopListCollection.where('productNo', isEqualTo: productNo).get();

    if (query.docs.isNotEmpty) {
      final DocumentSnapshot productDocument = query.docs.first;

      final bool currentStatus = productDocument.get('status');
      final bool newStatus = !currentStatus;

      await shopListCollection.doc(productDocument.id).update({
        'status': newStatus,
      });
    }
  }

// Update THEMECOLOR
  Future<void> updateThemeColor(int selectedColor) async {
    final DocumentReference userDocRef =
        database.doc('users/mecha/userinformation');
    await userDocRef.set({
      'settings': {
        'themecolor': selectedColor,
      }
    }, SetOptions(merge: true));
  }

//!! INSERT METHOD's !!\\

// Insert MYPRODUCT
  // Future<void> insertMyProduct(Map<String, dynamic> productMap) async {
  //   CollectionReference collectionReferenceProduct =
  //       database.collection('users/mecha/myproducts');
  //   await collectionReferenceProduct.add(productMap);
  // }

// Insert or Update MYPRODUCT
  // Future<void> insertOrUpdateMyProducts(MyProducts product) async {
  //   if (await isProductAlreadyExistInMyProduct(product)) {
  //     await updateMyProduct(product.toMap());
  //   } else {
  //     await insertMyProduct(product.toMap());
  //   }
  // }

// Insert MYPRODUCT FROM SHOPLIST
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
          database.collection('users/mecha/myproducts');

      // Adds the product 'myproducts' in Firebase Firestore
      await myProductsCollection.add({
        'productNo': value.productNo,
        'quantity': value.quantity,
        'gram': value.gram,
        'purchasedDay':
            DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day)
                .toString(),
        'expiredDay':
            DateTime(expiredDate.year, expiredDate.month, expiredDate.day)
                .toString(),
      });

      //Delete the producto from 'shoplist' in Firebase Firestore
      CollectionReference shopListCollection =
          database.collection('users/mecha/shoplist');
      QuerySnapshot querySnapshot = await shopListCollection
          .where('productNo', isEqualTo: value.productNo)
          .get();
      for (var doc in querySnapshot.docs) {
        await shopListCollection.doc(doc.id).delete();
      }
    }
  }

// Insert SHOPLIST
  Future<void> insertShopList(Map<String, dynamic> productMap) async {
    CollectionReference collectionReferenceProduct =
        database.collection('users/mecha/shoplist');
    await collectionReferenceProduct.add(productMap);
  }

// Insert or update SHOPLIST
  Future<void> insertOrUpdateIntoShopList(ShopList product) async {
    if (await isProductAlreadyExistInShopList(product)) {
      await updateShopList(product.toMap());
    } else {
      await insertShopList(product.toMap());
    }
  }







// ここから

//!! FIREBASE AUTH !! \\ß
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

//ここまで

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
}
