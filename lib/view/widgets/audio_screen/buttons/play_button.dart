import 'package:audio/controller/audio_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayButtons extends StatelessWidget {
  const PlayButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (con) => Positioned(
        top: AppDecoration().screenHeight * 0.8,
        width: AppDecoration().screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                con.previousButton();
              },
              icon: const Icon(
                Icons.skip_previous_rounded,
                color: AppColors.white,
                size: 40,
              ),
            ),
            SizedBox(width: AppDecoration().screenWidth * 0.02),
            IconButton(
              onPressed: () {
                con.playButton();
              },
              icon: Icon(
                con.isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: AppColors.white,
                size: 68,
              ),
            ),
            SizedBox(width: AppDecoration().screenWidth * 0.02),
            IconButton(
              onPressed: () {
                con.nextButton();
              },
              icon: const Icon(
                Icons.skip_next_rounded,
                color: AppColors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
