import 'dart:io';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/lifecycle.dart';
import 'package:audio/controller/theme_con.dart';
import 'package:audio/core/services/my_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:async';

AudioCon _audioCon = Get.put(AudioCon());
ArtWork _artworkCon = Get.put(ArtWork());

class ListCon extends GetxController {
  OnAudioQuery onAudio = OnAudioQuery();
  List<SongModel> dataFuture = [];
  Map hasImage = {};
  ConcatenatingAudioSource audioList =
      ConcatenatingAudioSource(children: [], useLazyPreparation: true);
  bool search = false;
  bool loading = false;
  TextEditingController searchCon = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String lastSearch = '';
  late Directory appDocs;
  late bool firstTime;
  late SharedPreferences sharedPreferences;
  late Box hiveBox;
  MyServices myServices = Get.find();
  ConcatenatingAudioSource savedAudioList =
      ConcatenatingAudioSource(children: []);
  List<SongModel> savedDataFuture = [];
  Map savedHasImg = {};
  bool pl = false;
  bool loadingPl = false;

  @override
  onInit() async {
    super.onInit();
    if (myServices.statusG) {
      appDocs = myServices.appDocs;
      Hive.init(appDocs.path);
      hiveBox = await Hive.openBox('audios');
      sharedPreferences = await SharedPreferences.getInstance();
      firstTime = hiveBox.isEmpty;
      if (sharedPreferences.getBool('saved') != true) {
        await notSaved();
      } else if (sharedPreferences.getBool('saved') == true) {
        await saved();
      }
    } else {
      PermissionStatus secondTime;
      if (myServices.androidVersion > 12) {
        secondTime = await Permission.audio.request();
      } else {
        secondTime = await Permission.storage.request();
      }
      if (secondTime.isDenied) {
        exit(0);
      } else {
        await Restart.restartApp();
      }
    }

    Get.put(ThemeController());
    Get.put(LifeCycle());
  }

  notSaved() async {
    loading = true;
    update();
    await dataFutureWithFilter();
    await hiveBox.clear();
    await Future.forEach(dataFuture, (audio) async {
      Uint8List? artwork;
      File file = File(
        '${appDocs.path}/${audio.title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png',
      );
      if (!(file.existsSync())) {
        artwork = await OnAudioQuery().queryArtwork(
          audio.id,
          ArtworkType.AUDIO,
          size: 1000,
          quality: 100,
          format: ArtworkFormat.PNG,
        );
        hasImage.addAll({audio.id.toString(): artwork == null ? false : true});
        update();
        if (artwork != null) {
          file.writeAsBytesSync(artwork);
        }
        await audioList.add(
          AudioSource.file(
            audio.data,
            tag: MediaItem(
              id: audio.id.toString(),
              title: audio.title,
              artUri: artwork == null ? null : Uri.file(file.path),
            ),
          ),
        );
      } else {
        hasImage.addAll({audio.id.toString(): true});
        update();
        await audioList.add(
          AudioSource.file(
            audio.data,
            tag: MediaItem(
              id: audio.id.toString(),
              title: audio.title,
              artUri: Uri.file(file.path),
            ),
          ),
        );
      }
    }).then((value) async {
      await hiveBox.put('savedAudios', hasImage);
      await sharedPreferences.setBool('saved', true);
      loading = false;
      firstTime = false;
      _audioCon.update();
      update();
    });
  }

  saved() async {
    Map savedAudios = hiveBox.isNotEmpty ? hiveBox.get('savedAudios') : {};
    await dataFutureWithFilter();
    if (savedAudios.length != dataFuture.length) {
      notSaved();
    } else {
      hasImage = savedAudios;
      await Future.forEach(
        dataFuture,
        (audio) async {
          await audioList.add(
            AudioSource.file(
              audio.data,
              tag: MediaItem(
                id: audio.id.toString(),
                title: audio.title,
                artUri: savedAudios[audio.id.toString()] == true
                    ? Uri.file(
                        '${appDocs.path}/${audio.title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png')
                    : null,
              ),
            ),
          );
        },
      );

      update();
    }
  }

  refreshList() async {
    loading = true;
    update();
    List refreshedDamaged = [];
    List<SongModel> refreshedList = await onAudio.querySongs(
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
      orderType: OrderType.DESC_OR_GREATER,
    );
    for (int i = 0; i < refreshedList.length; i++) {
      if (refreshedList[i].duration.toString().trim() == '0' ||
          refreshedList[i].title.trim().contains('tone') ||
          refreshedList[i].title.trim().toLowerCase().contains('yahoo -') ||
          refreshedList[i].title.trim().toLowerCase().contains('-wa') ||
          (refreshedList[i].duration != null &&
              refreshedList[i].duration! <= 2000)) {
        refreshedDamaged.add(refreshedList[i]);
      }
    }
    for (SongModel damagedAudio in refreshedDamaged) {
      // damaged  (yahoo - empty whats app audio- empty)
      refreshedList.remove(damagedAudio);
    }
    if (refreshedList.length != dataFuture.length) {
      await _audioCon.audioPlayer.stop();
      _audioCon.currentPath = '';
      _artworkCon.currentAudio = null;
      _artworkCon.update();
      audioList.clear();
      notSaved();
    } else {
      loading = false;
      _audioCon.update();
      update();
    }
  }

  dataFutureWithFilter() async {
    dataFuture = await onAudio.querySongs(
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
      orderType: OrderType.DESC_OR_GREATER,
    );
    dataFilter();
  }

  dataFilter() {
    List damaged = [];
    for (int i = 0; i < dataFuture.length; i++) {
      if (dataFuture[i].duration.toString().trim() == '0' ||
          dataFuture[i].title.trim().contains('tone') ||
          dataFuture[i].title.trim().toLowerCase().contains('yahoo -') ||
          dataFuture[i].title.trim().toLowerCase().contains('-wa') ||
          (dataFuture[i].duration != null && dataFuture[i].duration! <= 2000)) {
        damaged.add(dataFuture[i]);
      }
    }
    for (SongModel damagedAudio in damaged) {
      // damaged  (yahoo - empty whats app audio- empty)
      dataFuture.remove(damagedAudio);
    }
  }

  searching() {
    if (lastSearch != searchCon.text) {
      lastSearch = searchCon.text;
      search = true;
      update();
    }
  }

  Future<bool> exitSearch() {
    search = false;
    searchFocus.unfocus();
    searchCon.clear();
    update();
    return Future.value(false);
  }

  setPlaylist() async {
    pl = true;
    _audioCon.update();
    loadingPl = true;
    update();
    await _audioCon.audioPlayer.stop();
    _audioCon.isPlaying = false;
    _audioCon.currentPath = '';
    _audioCon.update();
    _artworkCon.currentAudio = null;
    _artworkCon.update();
    savedAudioList = audioList;
    savedDataFuture = dataFuture;
    savedHasImg = hasImage;
    ConcatenatingAudioSource audioInPl = ConcatenatingAudioSource(children: []);
    List<SongModel> audioPlData = [];
    Map<String, bool> plHasImg = {};
    for (SongModel audio in dataFuture) {
      if (audio
          .toString()
          .toLowerCase()
          .trim()
          .replaceAll('_', '')
          .replaceAll('-', '')
          .replaceAll('|', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('@', '')
          .replaceAll(' x ', '')
          .removeAllWhitespace
          .contains(searchCon.text
              .toLowerCase()
              .trim()
              .replaceAll('_', '')
              .replaceAll('-', '')
              .replaceAll('|', '')
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('@', '')
              .replaceAll(' x ', '')
              .removeAllWhitespace)) {
        audioPlData.add(audio);
        await audioInPl.add(
          AudioSource.file(
            audio.data,
            tag: MediaItem(
              id: audio.id.toString(),
              title: audio.title,
              artUri: savedHasImg[audio.id.toString()] == true
                  ? Uri.file(
                      '${appDocs.path}/${audio.title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png',
                    )
                  : null,
            ),
          ),
        );
        plHasImg.addAll(
          {audio.id.toString(): savedHasImg[audio.id.toString()]!},
        );
      }
    }
    audioList = audioInPl;
    dataFuture = audioPlData;
    hasImage = plHasImg;
    loadingPl = false;
    update();
  }

  removePlaylist() async {
    searchCon.clear();
    loadingPl = true;
    await _audioCon.audioPlayer.stop();
    _audioCon.isPlaying = false;
    _audioCon.currentPath = '';
    _audioCon.update();
    _artworkCon.currentAudio = null;
    _artworkCon.update();
    audioList = savedAudioList;
    dataFuture = savedDataFuture;
    hasImage = savedHasImg;
    pl = false;
    _audioCon.update();
    loadingPl = false;
    update();
  }
}




  // notSaved() async {
  //   loading = true;
  //   update();
  //   for (SongModel audio in dataFuture) {
  //     Uint8List? artwork = await OnAudioQuery().queryArtwork(
  //       audio.id,
  //       ArtworkType.AUDIO,
  //       size: 1000,
  //       format: ArtworkFormat.PNG,
  //     );

  //     File? file;
  //     if (artwork != null) {
  //       file = File(
  //         '${appDocs.path}/${audio.title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png',
  //       );
  //       await file.writeAsBytes(artwork);
  //     }
  //     audioList.add(
  //       AudioSource.file(
  //         audio.data,
  //         tag: MediaItem(
  //           id: audio.id.toString(),
  //           title: audio.title,
  //           artUri: artwork == null ? null : Uri.file(file!.path),
  //         ),
  //       ),
  //     );
  //     hasImage.add(artwork == null ? false : true);
  //     await hiveBox.put(
  //       'audio ${audioList.length - 1}',
  //       [
  //         audio.data,
  //         '${audio.id}',
  //         audio.title,
  //         artwork != null ? file!.path : 'null',
  //       ],
  //     );
  //     update();
  //   }
  //   await sharedPreferences.setBool('saved', true);
  //   loading = false;
  //   firstTime = false;
  //   _audioCon.update();
  //   update();
  // }

  // saved() async {
  //   int i = 0;
  //   loading = true;
  //   update();
  //   if (hiveBox.isNotEmpty) {
  //     for (SongModel _ in dataFuture) {
  //       List<String>? audioData = hiveBox.get('audio $i');
  //       if (audioData != null) {
  //         audioList.add(
  //           AudioSource.file(
  //             audioData[0],
  //             tag: MediaItem(
  //               id: audioData[1],
  //               title: audioData[2],
  //               artUri: audioData[3] != 'null' ? Uri.file(audioData[3]) : null,
  //             ),
  //           ),
  //         );
  //         hasImage.add(audioData[3] == 'null' ? false : true);
  //         update();
  //       }
  //       i++;
  //     }
  //   }
  //   if (audioList.length != dataFuture.length) {
  //     audioList.clear();
  //     for (SongModel audio in dataFuture) {
  //       Uint8List? artwork = await OnAudioQuery().queryArtwork(
  //         audio.id,
  //         ArtworkType.AUDIO,
  //         size: 1000,
  //       );
  //       File? file;
  //       if (artwork != null) {
  //         file = File(
  //             '${appDocs.path}/${audio.title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png');
  //         await file.writeAsBytes(artwork);
  //       }
  //       audioList.add(
  //         AudioSource.file(
  //           audio.data,
  //           tag: MediaItem(
  //             id: audio.id.toString(),
  //             title: audio.title,
  //             artUri: artwork == null ? null : Uri.file(file!.path),
  //           ),
  //         ),
  //       );
  //       hasImage.add(artwork == null ? false : true);
  //       update();
  //       await hiveBox.put(
  //         'audio ${audioList.length - 1}',
  //         [
  //           audio.data,
  //           '${audio.id}',
  //           audio.title,
  //           artwork != null ? file!.path : 'null',
  //         ],
  //       );
  //     }
  //     loading = false;
  //     _audioCon.update();
  //     update();
  //   } else {
  //     loading = false;
  //     _audioCon.update();
  //     update();
  //   }
  // }
