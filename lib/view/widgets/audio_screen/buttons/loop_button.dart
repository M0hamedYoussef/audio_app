import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/core/const/colors.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (con) => Positioned(
        top: AppDecoration().screenHeight * 0.6,
        left: AppDecoration().screenWidth * 0.01,
        right: AppDecoration().screenWidth * 0.78,
        child: InkWell(
          onTap: () {
            con.loopButton();
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 2, 20),
            child: Icon(
              Icons.loop,
              color: con.loop ? AppColors.blue : AppColors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
