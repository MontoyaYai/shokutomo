
import 'package:flutter/material.dart';

class MyRecipe extends StatelessWidget {
  const MyRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
        title: const Text('Myレシピ', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
     body:Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/coomingsoon.png'),
            fit: BoxFit.cover, // 画像を画面全体に広げる
          ),
        ),
      ),
    );
  }
}