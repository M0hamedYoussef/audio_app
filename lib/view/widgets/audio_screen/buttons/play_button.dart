import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/core/const/colors.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({required this.data, super.key});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCon>(
      builder: (con) => Positioned(
        top: AppDecoration().screenHeight * 0.8,
        left: AppDecoration().screenWidth * .1,
        right: AppDecoration().screenWidth * .1,
        child: Padding(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: IconButton(
            onPressed: () async {
              con.playButton(data: data);
            },
            icon: Icon(
              con.isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: AppColors.white,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
