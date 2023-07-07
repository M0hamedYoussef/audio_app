import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/core/const/colors.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioSlider extends StatelessWidget {
  const AudioSlider({required this.data, super.key});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (controller) => Positioned(
        top: AppDecoration().screenHeight * 0.725,
        left: AppDecoration().screenWidth * .06,
        right: AppDecoration().screenWidth * .03,
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
            thumbColor: Colors.white,
            inactiveColor: AppColors.white,
            activeColor: AppColors.blue,
            onChanged: (val) async {
              await controller.audioPlayer.seek(
                Duration(microseconds: val.toInt()),
              );
              controller.update();
            },
            onChangeStart: (value) async {
              await controller.pauseAudio();
            },
            onChangeEnd: (value) async {
              await controller.runAudio(data: data);
            },
          ),
        ),
      ),
    );
  }
}
