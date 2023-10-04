import 'package:flutter/material.dart';
// import '../../../widgets/app_bar_swipe.dart';

class MyFridge extends StatefulWidget {
  const MyFridge({Key? key}) : super(key: key);

  @override
  _MyFridgeState createState() => _MyFridgeState();
}

class _MyFridgeState extends State<MyFridge> {
  // final AppBarSwipe? appBarSwipe;
  // _MyFridgeState({required this.appBarSwipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My冷蔵庫',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/coomingsoon.png'),
            fit: BoxFit.cover, // 画像を画面全体に広げる
          ),
        ),
      ),
      // bottomNavigationBar: appBarSwipe != null ? appBarSwipe! : null,
    );
  }
}
