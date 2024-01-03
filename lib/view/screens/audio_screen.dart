import 'package:audio/controller/audio_con.dart';
import 'package:audio/controller/theme_con.dart';
import 'package:audio/view/widgets/audio_screen/audioBG/bg_blur.dart';
import 'package:audio/view/widgets/audio_screen/audioBG/bg_image.dart';
import 'package:audio/view/widgets/audio_screen/audio_details.dart';
import 'package:audio/view/widgets/audio_screen/audio_slider/audio_duration.dart';
import 'package:audio/view/widgets/audio_screen/audio_slider/audio_position.dart';
import 'package:audio/view/widgets/audio_screen/audio_slider/audio_slider.dart';
import 'package:audio/view/widgets/audio_screen/buttons/play_button.dart';
import 'package:audio/view/widgets/audio_screen/buttons/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    ThemeController themeCon = Get.find();

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          focusNode.unfocus();
          if (themeCon.currentTheme == 'light') {
            SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            );
          }
          Get.back();
          return Future(() => false);
        },
        child: Stack(
          children: [
            BgImage(data: audioData),
            const BgBlur(),
            AudioDetails(data: audioData), // with loop button and image
            const AudioSlider(),
            const ShareButton(),
            const AudioPosition(),
            const AudioDuration(),
            const PlayButtons(),
            // const CustomNextButton(),
            // const CustomBackButton(),
          ],
        ),
      ),
    );
  }
}
