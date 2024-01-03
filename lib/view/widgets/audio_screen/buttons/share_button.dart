import 'package:audio/controller/audio_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (con) => Positioned(
        top: AppDecoration().screenHeight * 0.59,
        left: AppDecoration().screenWidth * .84,
        child: IconButton(
          onPressed: () {
            con.shareAudio();
          },
          icon: const Icon(
            Icons.share,
            color: AppColors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
