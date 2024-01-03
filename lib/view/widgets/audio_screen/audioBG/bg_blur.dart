import 'package:audio/core/const/decoration.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class BgBlur extends StatelessWidget {
  const BgBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Blur(
      blurColor: Colors.transparent,
      blur: 3.5,
      colorOpacity: 0.12,
      child: SizedBox(
        height: AppDecoration().screenHeight,
        width: AppDecoration().screenWidth,
      ),
    );
  }
}
