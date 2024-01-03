import 'package:audio/controller/audio_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioSlider extends StatelessWidget {
  const AudioSlider({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (controller) => Positioned(
        top: AppDecoration().screenHeight * 0.73,
        width: AppDecoration().screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 5.0,
              ),
              trackHeight: 2,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              min: 0,
              max: double.parse(controller.d.inMicroseconds.toString()) >
                      double.parse(controller.p.inMicroseconds.toString())
                  ? double.parse(controller.d.inMicroseconds.toString())
                  : double.parse(controller.p.inMicroseconds.toString()),
              value: double.parse(controller.p.inMicroseconds.toString()),
              thumbColor: AppColors.white,
              inactiveColor: AppColors.white,
              activeColor: AppColors.blue,
              onChanged: (val) {
                controller.p = Duration(microseconds: val.toInt());
                controller.seeking = true;
                controller.update();
              },
              onChangeEnd: (value) async {
                await controller.audioPlayer.seek(
                  Duration(microseconds: value.toInt()),
                );
                controller.seeking = false;
                controller.update();
              },
            ),
          ),
        ),
      ),
    );
  }
}
