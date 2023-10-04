import 'package:flutter/material.dart';
import 'package:shokutomo/database/get_activity.dart';
import 'package:shokutomo/information_format/categories.dart';
import 'package:shokutomo/information_format/product_table.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/product_page.dart';
import 'select_product.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categories>>(
      future: GetActivity().getCategories(),
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
              String categoryName = categories[index].name;
              String categoryImage = categories[index].image;

              return Opacity(
                opacity: 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    int categoryNo = categories[index].no;

                    List<Products> products = await GetActivity().getAllProducts();

                    // Filter the products based on the selected category
                    List<Products> filteredProducts = products
                        .where((product) => product.categoryNo == categoryNo)
                        .toList();

                    // Convert the filtered products to a list of maps
                    List<Map<String, dynamic>> filteredProductsMap =
                        filteredProducts
                            .map((product) => product.toMap())
                            .toList();

                    // ignore: unused_label
                    child:
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          // ignore: sized_box_for_whitespace
                          content: Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // Adjust the width as needed
                        child: ProductPage(
                          selectProduct:
                              SelectProduct(products: filteredProductsMap),
                              categoryNo :categoryNo,
                        ),
                      )),

                      // ignore: use_build_context_synchronously
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
                        categoryImage,
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
