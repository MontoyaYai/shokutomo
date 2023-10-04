import 'package:flutter/material.dart';
import 'package:shokutomo/config/settings_page.dart';
import 'bottom_navigation_bar.dart';

import 'package:shokutomo/screens/mainPages/calendar/calendar_page.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/category_page.dart';
import 'package:shokutomo/screens/mainPages/inventary/inventary_page.dart';

import 'package:shokutomo/screens/subPages/myFridge/my_fridge.dart';
import 'package:shokutomo/screens/subPages/myRecipe/recipeBook/my_recipe.dart';
import 'package:shokutomo/screens/subPages/searchRecipe/search_recipe.dart';
import 'package:shokutomo/screens/subPages/shoppingList/list_shopping.dart';

class AppBarSwipe extends StatefulWidget {
  const AppBarSwipe({Key? key}) : super(key: key);

  @override
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                child:  Center(
                  child: Text(
                    'メニュー',
                    style: TextStyle(
                        // color: Colors.grey.shade800,
                        fontSize: titleFontSize,
                        // fontSize: 40,
                        fontWeight: FontWeight.bold),
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
                leading: const Icon(Icons.shopping_cart),
                title: const Text(
                  'ショッピングリスト',
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
                leading: const Icon(Icons.menu_book),
                title: const Text(
                  'レシピブック',
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
                leading: const Icon(Icons.search),
                title: const Text(
                  'レシピ検索',
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
                leading: const Icon(Icons.snowing),
                title: const Text(
                  'マイ冷蔵庫',
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
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  '設定',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pageController.animateToPage(
                    7,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          CalendarPage(),
          InventoryPage(),
          CategoryPage(),
          ShoppingList(),
          MyRecipe(),
          SearchRecipe(),
          MyFridge(),
          SettingsPage(),
          // ProductPage(),
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