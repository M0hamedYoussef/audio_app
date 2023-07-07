import 'package:audio_app/controller/art_con.dart';
import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/view/screens/audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_app/core/const/decoration.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RunningAudio extends GetView<AudioCon> {
  const RunningAudio({super.key, required this.data});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => AudioScreen(
            audioData: data,
            focusNode: FocusNode(),
            staticINDEX: controller.index,
          ),
          transition: Transition.downToUp,
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: AppDecoration().screenHeight * 0.11,
        ),
        clipBehavior: Clip.none,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: GetBuilder<ArtWork>(
            builder: (art) {
              if (controller.index == data.length) {
                controller.index--;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      QueryArtworkWidget(
                        id: data[controller.index].id,
                        type: ArtworkType.AUDIO,
                        size: 1000,
                        artworkFit: BoxFit.cover,
                        artworkQuality: FilterQuality.high,
                        artworkBorder: BorderRadius.circular(10),
                        nullArtworkWidget: const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          data[controller.index].title.toString().length > 14
                              ? data[controller.index]
                                  .title
                                  .toString()
                                  .substring(0, 14)
                                  .replaceRange(14, 14, '...')
                              : data[controller.index].title.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  GetBuilder<AudioCon>(
                    builder: (controller) => Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.previousButton(data: data);
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.playButton(data: data);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              controller.isPlaying == false
                                  ? Icons.play_circle
                                  : Icons.pause_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.nextButton(data: data);
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
