import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/view/widgets/audio_screen/audioBG/bg_blur.dart';
import 'package:audio_app/view/widgets/audio_screen/audioBG/bg_image.dart';
import 'package:audio_app/view/widgets/audio_screen/audio_image.dart';
import 'package:audio_app/view/widgets/audio_screen/audio_name.dart';
import 'package:audio_app/view/widgets/audio_screen/audio_slider/audio_duration.dart';
import 'package:audio_app/view/widgets/audio_screen/audio_slider/audio_position.dart';
import 'package:audio_app/view/widgets/audio_screen/audio_slider/audio_slider.dart';
import 'package:audio_app/view/widgets/audio_screen/buttons/previous_button.dart';
import 'package:audio_app/view/widgets/audio_screen/buttons/loop_button.dart';
import 'package:audio_app/view/widgets/audio_screen/buttons/next_button.dart';
import 'package:audio_app/view/widgets/audio_screen/buttons/play_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioScreen extends GetView<AudioCon> {
  const AudioScreen({
    super.key,
    required this.audioData,
    required this.staticINDEX,
    required this.focusNode,
  });
  final dynamic audioData;
  final FocusNode focusNode;
  final int staticINDEX;

  @override
  Widget build(BuildContext context) {
    controller.index = staticINDEX;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          focusNode.unfocus();
          Get.back();
          return Future(() => false);
        },
        child: Stack(
          children: [
            BgImage(data: audioData),
            const BgBlur(),
            AudioImage(data: audioData),
            AudioName(data: audioData),
            AudioSlider(data: audioData),
            CustomNextButton(data: audioData),
            CustomBackButton(data: audioData),
            const LoopButton(),
            Stack(
              alignment: Alignment.center,
              children: [
                const AudioPosition(),
                const AudioDuration(),
                PlayButton(data: audioData),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
