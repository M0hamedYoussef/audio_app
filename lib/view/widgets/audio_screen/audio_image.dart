import 'package:audio_app/controller/art_con.dart';
import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioImage extends GetView<AudioCon> {
  const AudioImage({required this.data, super.key});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArtWork>(
      builder: (con) {
        if (controller.index == data.length) {
          controller.index--;
        }
        return Positioned(
          left: 0,
          top: AppDecoration().screenHeight * 0.05,
          right: AppDecoration().screenWidth * 0.02,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(19, 80, 8, 15),
            child: QueryArtworkWidget(
              id: data[controller.index].id,
              type: ArtworkType.AUDIO,
              size: 1000,
              artworkHeight: AppDecoration().screenWidth * 1,
              artworkWidth: AppDecoration().screenWidth * 0.8,
              artworkFit: BoxFit.contain,
              artworkQuality: FilterQuality.high,
              quality: 100,
              nullArtworkWidget: const SizedBox(),
            ),
          ),
        );
      },
    );
  }
}
