import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioImage extends GetView<AudioCon> {
  const AudioImage({required this.data, super.key});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArtWork>(
      builder: (_) {
        if (controller.index == data.length) {
          controller.index--;
        }
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: AppDecoration().screenHeight * 0.5,
              maxWidth: AppDecoration().screenWidth * 0.95,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 175, top: 8, left: 8, right: 8),
              child: QueryArtworkWidget(
                id: data[controller.index].id,
                type: ArtworkType.AUDIO,
                size: 1000,
                artworkBorder: BorderRadius.zero,
                artworkQuality: FilterQuality.high,
                artworkHeight: AppDecoration().screenHeight,
                artworkWidth: AppDecoration().screenWidth,
                artworkFit: BoxFit.fitWidth,
                quality: 100,
                nullArtworkWidget: const SizedBox(),
              ),
            ),
          ),
        );
      },
    );
  }
}
