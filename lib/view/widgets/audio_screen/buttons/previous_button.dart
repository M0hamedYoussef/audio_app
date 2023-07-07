import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/core/const/colors.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomBackButton extends GetView<AudioCon> {
  const CustomBackButton({required this.data, super.key});
  final List<SongModel> data;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppDecoration().screenHeight * 0.820,
      right: AppDecoration().screenWidth * 0.5,
      left: AppDecoration().screenWidth * .01,
      child: Padding(
        padding: const EdgeInsets.only(left: 60.0, right: 60.0),
        child: InkWell(
          onTap: () async {
            controller.previousButton(data: data);
          },
          child: const Icon(
            Icons.skip_previous_rounded,
            color: AppColors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
