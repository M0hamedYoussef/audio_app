import 'dart:io';
import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/controller/list_con.dart';
import 'package:audio/controller/theme_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:audio/core/const/image_asset.dart';
import 'package:audio/core/services/my_services.dart';
import 'package:audio/view/screens/audio_screen.dart';
import 'package:audio/view/widgets/home/running.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
    MyServices myServices = Get.find();
    ListCon listCon = Get.find();
    FocusNode listTileFocus = FocusNode();
    ThemeController themeCon = Get.find();
    String path = listCon.dataFuture[currentIndex].data;

    return GetBuilder<AudioCon>(
      builder: (_) {
        return ListTile(
          textColor:
              audioCon.currentPath == path ? AppColors.boldBlueSecond : null,
          onTap: () async {
            if (themeCon.currentTheme == 'light') {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
              );
            }
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
              await audioCon.runAudio();
            }
          },
          onLongPress: () {
            audioCon.showDetails(tileIndex: currentIndex);
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage:
                listCon.hasImage[data[currentIndex].id.toString()] ?? false
                    ? FileImage(
                        File(
                          '${myServices.appDocs.path}/${data[currentIndex].title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png',
                        ),
                      )
                    : null,
            backgroundColor: themeCon.currentTheme == 'light'
                ? AppColors.bg
                : ThemeData.dark(useMaterial3: true).cardColor,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data[currentIndex].title,
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data[currentIndex].artist == null
                        ? ''
                        : data[currentIndex].artist == '<unknown>'
                            ? ''
                            : data[currentIndex].artist!.length > 20
                                ? '${data[currentIndex].artist!.substring(0, 20)}...'
                                : data[currentIndex].artist!,
                    style: const TextStyle(fontSize: 15),
                  ),
                  if (audioCon.currentPath == path)
                    Lottie.asset(
                      AppImageAsset.runningAudio,
                      height: AppDecoration().screenHeight * 0.03,
                      animate: audioCon.isPlaying ? true : false,
                    ),
                ],
              ),
            ],
          ),
          focusNode: listTileFocus,
        );
      },
    );
  }
}
