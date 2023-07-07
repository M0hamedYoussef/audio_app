import 'package:audio_app/controller/art_con.dart';
import 'package:audio_app/view/widgets/home/running.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class AudioCon extends GetxController {
  OnAudioQuery onAudio = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();
  Duration d = const Duration(seconds: 0);
  Duration p = const Duration(seconds: 0);
  late bool isPlaying;
  late String currentPath;
  int index = 0;
  bool loop = false;
  ArtWork artCon = Get.find();
  FocusNode listTileFocus = FocusNode();
  @override
  onInit() async {
    PermissionStatus status = await Permission.storage.status;
    isPlaying = false;
    currentPath = 'none';
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    audioPlayer.durationStream.listen((duration) {
      d = duration ?? Duration.zero;
    });
    audioPlayer.positionStream.listen((pos) {
      p = pos;
      update();
    });

    audioPlayer.playerStateStream.listen(
      (event) async {
        if (event.processingState == ProcessingState.completed) {
          await audioPlayer.stop();
          isPlaying = false;
          update();
        }
      },
    );

    super.onInit();
  }

  runAudio({required List<SongModel> data}) async {
    isPlaying = true;
    update();
    if (data[index].data == currentPath &&
        audioPlayer.playerState.processingState == ProcessingState.idle) {
      await audioPlayer.setAudioSource(AudioSource.file(data[index].data));
      await audioPlayer.play();
    } else if (data[index].data == currentPath) {
      await audioPlayer.play();
    } else {
      currentPath = data[index].data;
      await audioPlayer.setAudioSource(AudioSource.file(data[index].data));
      await audioPlayer.play();
    }
  }

  pauseAudio() async {
    isPlaying = false;
    update();
    await audioPlayer.pause();
  }

  playButton({required List<SongModel> data}) async {
    isPlaying = !isPlaying;
    if (isPlaying) {
      await runAudio(data: data);
    } else {
      await pauseAudio();
    }
  }

  nextButton({required List<SongModel> data}) async {
    if (data.length - 1 > index) {
      index++;
      artCon.currentAudio = RunningAudio(data: data);
      artCon.update();
      await runAudio(data: data);
    } else if (data.length - 1 == index) {
      index != 0 ? artCon.update() : null;
      index = 0;
      artCon.currentAudio = RunningAudio(data: data);
      artCon.update();
      await runAudio(data: data);
    } else {
      index--;
      artCon.currentAudio = RunningAudio(data: data);
      artCon.update();
      await runAudio(data: data);
    }
  }

  previousButton({required List<SongModel> data}) async {
    if (index != 0 && data.length - 1 >= index) {
      index--;
      artCon.currentAudio = RunningAudio(data: data);
      artCon.update();
      await runAudio(data: data);
    } else {
      index = data.length - 1;
      artCon.currentAudio = RunningAudio(data: data);
      artCon.update();
      await runAudio(data: data);
    }
  }

  loopButton() async {
    loop = !loop;
    loop
        ? await audioPlayer.setLoopMode(LoopMode.one)
        : await audioPlayer.setLoopMode(LoopMode.off);
    update();
  }
}
