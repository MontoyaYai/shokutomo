import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/create_record.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/select_product.dart';
import '../../../widgets/app_bar_swipe.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  final AppBarSwipe? appBarSwipe;
  final SelectProduct? selectProduct;
  final int? categoryNo;

  const ProductPage({
    Key? key,
    this.appBarSwipe,
    this.selectProduct,
    this.categoryNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            insetPadding: EdgeInsets.zero,
            elevation: 0.0, // Set elevation to 0.0 to remove the shadow
            backgroundColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '食材検索',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'x',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.0, // Increase the font size here
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //　search Bar
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 8.0, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      searchProvider.searchText = value;
                      Future<List<Product>> searchResults =
                          getSearchResults(searchProvider.searchText);
                      searchResults.then((List<Product> results) {
                        searchProvider.setSearchResults(results);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: '検索',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ), //Search Bar

                Expanded(
                    child: Column(
                  children: searchProvider._searchResults.isNotEmpty
                      ? [
                          // 検索結果ListView
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchProvider._searchResults.length,
                              itemBuilder: (context, index) {
                                Product result =
                                    searchProvider._searchResults[index];
                                return ListTile(
                                  title: Text(result.productName),
                                  leading: Image.asset("assets/img/${result.image}"),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CreateRecordDialog(
                                              productName: result.productName);
                                        });
                                  },
                                );
                              },
                            ),
                          ), //検索結果ListView

                          const Divider(
                            height: 20,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.grey,
                          ),

                          Expanded(
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              child: selectProduct ?? Container(),
                            ),
                          ),
                        ]
                      : [
                          const Divider(
                            height: 20,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              child: selectProduct ?? Container(),
                            ),
                          ),
                        ],
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<Product>> getSearchResults(String searchText) {
    return GetFirebaseDataToArray().searchProductsInArray(searchText);
  }
}

//　search state を保存するクラス
class SearchProvider extends ChangeNotifier {
  String _searchText = '';
  List<Product> _searchResults = [];

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setSearchResults(List<Product> results) {
    _searchResults = results;
    notifyListeners();
  }
}
