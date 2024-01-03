import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/view/widgets/audio_screen/buttons/loop_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioDetails extends GetView<AudioCon> {
  const AudioDetails({required this.data, super.key});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArtWork>(
      builder: (_) => Positioned(
        top: AppDecoration().screenHeight * .05,
        left: AppDecoration().screenWidth * 0.05,
        right: AppDecoration().screenWidth * 0.05,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: AppDecoration().screenHeight * 0.5,
                  maxWidth: AppDecoration().screenWidth * 0.95,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 150,
                    left: 8,
                    right: 8,
                  ),
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
                    nullArtworkWidget: SizedBox(
                      height: AppDecoration().screenHeight * 0.5,
                      width: AppDecoration().screenWidth * 0.95,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDecoration().screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
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
                maxLines: 1,
              ),
            ),
            const LoopButton(),
          ],
        ),
      ),
    );
  }
}
