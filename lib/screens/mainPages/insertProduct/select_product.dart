import 'package:flutter/material.dart';
import 'package:shokutomo/database/sql.dart';
import 'create_record.dart';

class SelectProduct extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const SelectProduct({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 3.0, left: 3.0, right: 3.0),
                      child: Image.asset(
                        products[index][SQL.columnProductImage],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      products[index][SQL.columnProductName],
                      style: const TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
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
                      productName: products[index][SQL.columnProductName]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
