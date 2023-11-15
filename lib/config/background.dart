import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

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
          
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset(
          //     "assets/img/bottom1.png",
          //     width: size.width
          //   ),
          // ),
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