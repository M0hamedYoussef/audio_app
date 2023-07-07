import 'package:audio_app/controller/art_con.dart';
import 'package:audio_app/controller/audio_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioName extends GetView<AudioCon> {
  const AudioName({required this.data, super.key});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArtWork>(
      builder: (con) => Positioned(
        top: AppDecoration().screenHeight * .568,
        left: AppDecoration().screenWidth * 0.1,
        right: AppDecoration().screenWidth * 0.1,
        child: Text(
          data[controller.index].title.toString().length > 19
              ? data[controller.index]
                  .title
                  .toString()
                  .substring(0, 19)
                  .replaceRange(19, 19, '...')
              : data[controller.index].title.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
