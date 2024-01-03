import 'package:audio/controller/audio_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (con) => IconButton(
        onPressed: () {
          con.loopButton();
        },
        icon: Icon(
          Icons.loop,
          color: con.loop ? AppColors.blue : AppColors.white,
          size: 30,
        ),
      ),
    );
  }
}
