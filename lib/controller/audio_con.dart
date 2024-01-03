import 'dart:io';
import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/list_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:audio/core/services/my_services.dart';
import 'package:audio/view/widgets/home/running.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class AudioCon extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration d = const Duration(seconds: 0);
  Duration p = const Duration(seconds: 0);
  Duration repeatTimer = const Duration(seconds: 0);
  late bool isPlaying;
  late String currentPath;
  int index = 0;
  bool loop = false;
  bool shuffleMode = false;
  ArtWork artCon = Get.find();
  FocusNode listTileFocus = FocusNode();
  ListCon listCon = Get.find();
  MyServices myServices = Get.find();
  bool seeking = false;
  bool deleting = false;

  @override
  onInit() async {
    isPlaying = false;
    currentPath = '';
    await audioPlayer.setLoopMode(LoopMode.all);
    audioPlayerListener();
    super.onInit();
  }

  audioPlayerListener() {
    audioPlayer.durationStream.listen((duration) async {
      d = duration ?? Duration.zero;
      update();
    });
    audioPlayer.positionStream.listen((pos) async {
      if (d != Duration.zero) {
        if (!seeking) {
          p = pos;
          update();
        }
        // if (loop &&
        //     double.parse(pos.toString().replaceAll(':', '')).ceil() ==
        //         double.parse(d.toString().replaceAll(':', '')).ceil()) {
        //   seeking = true;
        //   await audioPlayer.seek(Duration.zero);
        //   seeking = false;
        // }
      }
    });
    audioPlayer.playerStateStream.listen(
      (event) async {
        if (audioPlayer.currentIndex != null &&
            !event.playing &&
            p == Duration.zero &&
            event.processingState == ProcessingState.ready) {
          runAudio();
        }
        if (event.processingState == ProcessingState.idle &&
            p != Duration.zero &&
            !listCon.loadingPl &&
            !listCon.loading &&
            !deleting) {
          exit(0);
        } else if (!event.playing) {
          isPlaying = false;
          update();
        } else if (event.playing) {
          isPlaying = true;
          update();
        }
      },
    );

    audioPlayer.currentIndexStream.listen(
      (event) async {
        if (audioPlayer.currentIndex != null) {
          index = audioPlayer.currentIndex!;
          p = Duration.zero;
          currentPath = listCon.dataFuture[index].data;
          artCon.currentAudio = RunningAudio(data: listCon.dataFuture);
          artCon.update();
        }
      },
    );
  }

  runAudio() async {
    if (listCon.dataFuture[index].data == currentPath) {
      await audioPlayer.play();
    } else {
      currentPath = listCon.dataFuture[index].data;
      await audioPlayer.setAudioSource(
        listCon.audioList,
        initialIndex: index,
      );
      await audioPlayer.play();
    }
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  playButton() async {
    isPlaying = !isPlaying;
    if (isPlaying) {
      await runAudio();
    } else {
      await pauseAudio();
    }
  }

  nextButton() async {
    if (listCon.dataFuture.length > 1) {
      seeking = true;
      if (index != listCon.dataFuture.length - 1) {
        if (loop) {
          await audioPlayer.setLoopMode(LoopMode.all);
          await audioPlayer.seekToNext();
          await audioPlayer.setLoopMode(LoopMode.one);
        } else {
          await audioPlayer.seekToNext();
        }
      } else {
        await audioPlayer.setAudioSource(
          listCon.audioList,
          initialIndex: 0,
        );
        await audioPlayer.play();
      }
      seeking = false;
    } else {
      await audioPlayer.seek(Duration.zero);
    }

    //if (data.length - 1 > index) {
    //   index++;
    //   await runAudio(data: data);
    // } else if (data.length - 1 == index) {
    //   index != 0 ? artCon.update() : null;
    //   index = 0;
    //   artCon.currentAudio = RunningAudio(data: data);
    //   artCon.update();
    //   await runAudio(data: data);
    // } else {
    //   index--;
    //   artCon.currentAudio = RunningAudio(data: data);
    //   artCon.update();
    //   await runAudio(data: data);
    // }
  }

  previousButton() async {
    if (listCon.dataFuture.length > 1) {
      seeking = true;
      if (index == 0) {
        await audioPlayer.setAudioSource(
          listCon.audioList,
          initialIndex: listCon.dataFuture.length - 1,
        );
        await audioPlayer.play();
      } else {
        if (loop) {
          await audioPlayer.setLoopMode(LoopMode.all);
          await audioPlayer.seekToPrevious();
          await audioPlayer.setLoopMode(LoopMode.one);
        } else {
          await audioPlayer.seekToPrevious();
        }
      }
      seeking = false;
    } else {
      await audioPlayer.seek(Duration.zero);
    }

    // if (index != 0 && data.length - 1 >= index) {
    //   index--;
    //   artCon.currentAudio = RunningAudio(data: data);
    //   artCon.update();
    //   await runAudio(data: data);
    // } else {
    //   index = data.length - 1;
    //   artCon.currentAudio = RunningAudio(data: data);
    //   artCon.update();
    //   await runAudio(data: data);
    // }
  }

  loopButton() async {
    loop = !loop;
    loop
        ? await audioPlayer.setLoopMode(LoopMode.one)
        : await audioPlayer.setLoopMode(LoopMode.all);
    update();
  }

  shareAudio() async {
    await Share.shareXFiles([XFile(listCon.dataFuture[index].data)]);
  }

  shuffle() async {
    shuffleMode = !shuffleMode;
    update();
    await audioPlayer.setShuffleModeEnabled(shuffleMode);
  }

  showDetails({required int tileIndex}) async {
    SongModel tileModel = listCon.dataFuture[tileIndex];
    XFile audioFile = XFile(tileModel.data);

    Get.bottomSheet(
      IntrinsicHeight(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: AppColors.white,
          ),
          width: AppDecoration().screenWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Location : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: audioFile.path,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.01),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Name : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: audioFile.name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.01),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Last Modified : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: (await audioFile.lastModified())
                            .toString()
                            .substring(0, 19),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.01),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Size : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${(await audioFile.length() / 1000 / 1000).toString().substring(0, 4)} MB',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.02),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                    ThemeData.dark(useMaterial3: true).cardColor,
                  )),
                  onPressed: () async {
                    PermissionStatus externalStorage =
                        await Permission.manageExternalStorage.request();

                    if (externalStorage.isGranted) {
                      File toDelete = File(audioFile.path);
                      await toDelete.delete();
                      listCon.dataFuture.remove(
                        tileModel,
                      );
                      Get.back();
                      deleting = true;
                      if (currentPath == tileModel.data) {
                        await audioPlayer.stop();
                        isPlaying = false;
                        currentPath = '';
                        update();
                        artCon.currentAudio = null;
                        artCon.update();
                      }
                      await listCon.hasImage.remove(
                        tileModel.id.toString(),
                      );
                      await listCon.audioList.removeAt(tileIndex);
                      await listCon.hiveBox
                          .put('savedAudios', listCon.hasImage);
                      listCon.update();
                      deleting = false;
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
