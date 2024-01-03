import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BgImage extends GetView<AudioCon> {
  const BgImage({required this.data, super.key});

  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArtWork>(
      builder: (con) {
        if (controller.index == data.length) {
          controller.index--;
        }
        return QueryArtworkWidget(
          id: data[controller.index].id,
          type: ArtworkType.AUDIO,
          size: 1000,
          artworkFit: BoxFit.cover,
          artworkHeight: AppDecoration().screenHeight,
          artworkWidth: AppDecoration().screenWidth,
          artworkQuality: FilterQuality.high,
          quality: 100,
          artworkBorder: BorderRadius.zero,
          nullArtworkWidget: const SizedBox(),
        );
      },
    );
  }
}
