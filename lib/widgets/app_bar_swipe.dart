import 'package:flutter/material.dart';
import 'package:shokutomo/config/settings_page.dart';
import 'package:shokutomo/text_recognition/vision_detector_views/text_detector_view.dart';
import 'bottom_navigation_bar.dart';

import 'package:shokutomo/screens/mainPages/calendar/calendar_page.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/category_page.dart';
import 'package:shokutomo/screens/mainPages/inventary/inventary_page.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/search_recipe.dart';
import 'package:shokutomo/screens/subPages/shoppingList/list_shopping.dart';

class AppBarSwipe extends StatefulWidget {
  const AppBarSwipe({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppBarSwipeState createState() => _AppBarSwipeState();
}

class _AppBarSwipeState extends State<AppBarSwipe> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    // Color secondaryColor = AppTheme().theme().colorScheme.secondary;

    double availableHeight = MediaQuery.of(context).size.height * 0.4;
    double titleFontSize = availableHeight * 0.1;

    return Scaffold(
      key: scaffoldKey,
      drawer: Align(
        alignment: Alignment.centerRight,
        child: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/fondo_sushi_transparent.png'),
                // fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration:
                      BoxDecoration(color: primaryColor.withOpacity(0.1)),
                  child: Center(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/img/tomo.png',
                          width: 80, // ajusta el ancho según sea necesario
                          height: 80, // ajusta la altura según sea necesario
                        ),
                        // const SizedBox(width: 8), /s/ Espacio entre la imagen y el texto

                        Text(
                          'メニュー',
                          style: TextStyle(
                              // color: Colors.grey.shade800,
                              fontSize: titleFontSize,
                              // fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text(
                    'カレンダー',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text(
                    'カメラでまとめ登録',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                   Navigator.pop(context);
                    _pageController.animateToPage(
                      3,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text(
                    'ショッピングリスト',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(
                      4,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: const Text(
                    'レシピブック',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(
                      5,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text(
                    '設定',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(
                      6,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          CalendarPage(),
          InventoryPage(),
          CategoryPage(),
          TextRecognizerView(),
          ShoppingList(),
          SearchRecipe(),
          SettingsPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          }
        },
        menuButtonIndex: 3,
        onMenuButtonTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        drawer: const Drawer(),
      ),
    );
  }
}
