import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioDuration extends StatelessWidget {
  const AudioDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (con) => Positioned(
        top: AppDecoration().screenHeight * 0.8 * 0.8 + 90,
        left: AppDecoration().screenWidth * 0.8,
        right: AppDecoration().screenWidth * .1 - 10,
        child: Text(
          con.d.toString().substring(0, 7),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
