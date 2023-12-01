import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/firebase/product_json_map.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/create_record.dart';
import 'package:shokutomo/firebase/productforsearch_json_map.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/select_category.dart';
import '../../../widgets/app_bar_swipe.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final AppBarSwipe? appBarSwipe;

  const CategoryPage({Key? key, this.appBarSwipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          ThemeData theme = Theme.of(context);

          return Container(
              // color: primaryColor,
              color: Colors.white,
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                  elevation: 0,
                    automaticallyImplyLeading: true,
                    title: const Text(
                      'カテゴリー選択',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: theme.appBarTheme
                        .backgroundColor, // Personaliza el color de fondo de la AppBar
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 20, left: 10.0, bottom: 8.0),
                        child: Text(
                          '食材選択',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // search bar
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 8.0, right: 20),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) async {
                            searchProvider._searchText = value;
                            searchProvider.showSearchResults = true;
                            List<Product> searchResults =
                               await GetFirebaseDataToArray().searchProductsInArray(searchProvider.searchText);
                             searchProvider.setSearchResults(searchResults);
                          },
                          decoration: const InputDecoration(
                            hintText: '検索',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ), // search bar
                      Expanded(
                        child: Column(
                          //　検索結果が有る際のみListViewのExpandedを表示する
                          children: searchProvider._searchResults.isNotEmpty &&
                                  searchProvider
                                      ._showSearchResults //ListView　Expanded 表示の条件
                              ? [
                                  Flexible(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          searchProvider._searchResults.length,
                                      itemBuilder: (context, index) {
                                        Product result =
                                            searchProvider
                                                ._searchResults[index];
                                        return ListTile(
                                            title: Text(result.productName),
                                            leading: Image.asset("assets/img/${result.image}"
                                                ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CreateRecordDialog(
                                                        productName:
                                                            result.productName);
                                                  }).then((value) {
                                                searchProvider
                                                    .showSearchResults = false;
                                                searchController.text = '';
                                              });
                                            });
                                      },
                                    ),
                                  ),
                                  const Divider(
                                    height: 20,
                                    thickness: 2,
                                    indent: 5,
                                    endIndent: 5,
                                    color: Colors.grey,
                                  ),
                                  const Expanded(child: SelectCategory()),
                                ]
                              : [
                                  const Divider(
                                    height: 20,
                                    thickness: 2,
                                    indent: 5,
                                    endIndent: 5,
                                    color: Colors.grey,
                                  ),
                                  const Expanded(child: SelectCategory()),
                                ],
                        ),
                      )
                    ],
                  ),
                  bottomNavigationBar:
                      appBarSwipe != null ? appBarSwipe! : null,
                ),
              ));
        },
      ),
    );
  }

}

//　search state を保存するクラス
class SearchProvider extends ChangeNotifier {
  String _searchText = '';
  List<Product> _searchResults = [];
  bool _showSearchResults = true;

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setSearchResults(List<Product> results) {
    _searchResults = results;
    notifyListeners();
  }

  set showSearchResults(bool value) {
    _showSearchResults = value;
    notifyListeners();
  }
}
