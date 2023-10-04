import 'package:flutter/material.dart';
import 'package:shokutomo/screens/mainPages/insertProduct/category_page.dart';
import 'dart:async';

import '../widgets/app_bar_swipe.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const CategoryPage(appBarSwipe: AppBarSwipe()),
        ),
        (route) => false, // Remove all previous routes
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double imageHeight = constraints.maxHeight * 0.5;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    "assets/img/LOGO_ANIMATED.gif",
                    width: MediaQuery.of(context).size.width,
                    height: imageHeight,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}