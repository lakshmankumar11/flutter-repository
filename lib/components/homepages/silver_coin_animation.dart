import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SilverCoinAnimation extends StatelessWidget {
  final double width;
  final double height;
  final bool repeat;
  final String assetPath;
  final BoxFit fit;

  const SilverCoinAnimation({
    super.key,
    this.width = 150,
    this.height = 150,
    this.repeat = true,
    this.assetPath = 'assets/animations/silver_coin_star.json',
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      repeat: repeat,
      fit: fit,
    );
  }
}
