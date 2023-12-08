import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';

class MyRecipeTab extends StatelessWidget {
  const MyRecipeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FutureBuilder<List<MyProducts>>(
            future: GetFirebaseDataToArray().myProductsArray(),
            builder: (context, myProductsSnapshot) {
              if (myProductsSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (myProductsSnapshot.hasError) {
                return Text('Error: ${myProductsSnapshot.error}');
              } else {
                final myProducts = myProductsSnapshot.data!;
                return GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(20.0),
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    for (var product in myProducts)
                      ElevatedButton(
                        onPressed: () {
                          // Acción del botón
                          // Puedes agregar lógica específica para cada producto aquí
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Imagen del producto
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/img/${product.image}"),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Texto con el nombre del producto
                            Text(product.name),
                          ],
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Acción del botón para agregar nuevos productos
          },
          child:
          const Text('レーシピを追加する', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
