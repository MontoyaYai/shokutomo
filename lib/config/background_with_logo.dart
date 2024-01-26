import 'package:flutter/material.dart';

class BackgroundWithLogo extends StatelessWidget {
  final Widget child;

  const BackgroundWithLogo({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/img/top1.png",
              width: size.width
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/img/top2.png",
              width: size.width
            ),
          ),
          Positioned(
            top: 95,
            left: 30,
            child: Image.asset(
              "assets/img/LOGO.png",
              width: size.width * 0.35
            ),
          ),
          
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/img/bottom2.png",
              width: size.width
            ),
          ),
          child
        ],
      ),
    );
  }
}