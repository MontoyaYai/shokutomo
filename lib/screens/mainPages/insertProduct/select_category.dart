import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/categories_json_map.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/product_page.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/select_product.dart'; // Importa la clase FirebaseServices

class SelectCategory extends StatelessWidget {
  const SelectCategory({super.key});

  @override
  Widget build(BuildContext context) {
  
    return FutureBuilder<List<Categories>>(

      future: GetFirebaseDataToArray().categories, 
          
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Categories> categories = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 5),
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemBuilder: (context, index) {
              String categoryName = categories[index]
                  .name;
              String categoryImage =
                  categories[index].image; 

           
              return Opacity(
                opacity: 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    List<Product> allProducts =
                        await GetFirebaseDataToArray().productsArray();
                    int selectedCategoryNo = categories[index].no;
                    List<Product> filteredProductsMap =
                        allProducts.where((product) {
                      int productCategoryNo = product.categoryNo;
                      return productCategoryNo == selectedCategoryNo;
                    }).toList();
                    // ignore: unused_label
                    child:
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ProductPage(
                            selectProduct:
                                SelectProduct(products: filteredProductsMap),
                            categoryNo: categories[index].no,
                          ),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/$categoryImage',
                        width: 40.0,
                        height: 40.0,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('エラー発生しています');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
