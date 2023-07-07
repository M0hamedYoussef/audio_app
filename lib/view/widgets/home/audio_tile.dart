import 'package:audio_app/controller/art_con.dart';
import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/view/screens/audio_screen.dart';
import 'package:audio_app/view/widgets/home/running.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioTile extends StatelessWidget {
  const AudioTile({
    required this.currentIndex,
    required this.data,
    super.key,
  });

  final List<SongModel> data;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    AudioCon audioCon = Get.find();
    ArtWork artCon = Get.find();
    FocusNode listTileFocus = FocusNode();
    return ListTile(
      onTap: () async {
        Get.to(
          () => AudioScreen(
            audioData: data,
            focusNode: listTileFocus,
            staticINDEX: currentIndex,
          ),
          transition: Transition.downToUp,
        );
        if (audioCon.currentPath != data[currentIndex].data) {
          audioCon.index = currentIndex;
          artCon.currentAudio = RunningAudio(data: data);
          artCon.update();
          await audioCon.runAudio(data: data);
        }
      },
      leading: QueryArtworkWidget(
        id: data[currentIndex].id,
        type: ArtworkType.AUDIO,
        size: 1000,
        nullArtworkWidget: const SizedBox(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data[currentIndex].title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            data[currentIndex].artist == null
                ? ''
                : data[currentIndex].artist == '<unknown>'
                    ? ''
                    : data[currentIndex].artist ?? '',
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
      focusNode: listTileFocus,
    );
  }
}
