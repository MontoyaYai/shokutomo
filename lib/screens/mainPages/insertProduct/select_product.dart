import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'create_record.dart';

class SelectProduct extends StatelessWidget {
  final List<Product> products;

  const SelectProduct({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          String productImage = products[index].image;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Ajusta según tus preferencias
    ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 3.0, left: 3.0, right: 3.0),
                      child: Image.asset(
                        'assets/img/$productImage', 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      
                      products[index].productName, 
                      style: const TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateRecordDialog(
                      productName: products[index].productName); 
                },
              );
            },
          );
        },
      ),
    );
  }
}
