import 'dart:io';
import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/controller/list_con.dart';
import 'package:audio/controller/theme_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/services/my_services.dart';
import 'package:audio/view/screens/audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RunningAudio extends GetView<AudioCon> {
  const RunningAudio({super.key, required this.data});
  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();
    ListCon listCon = Get.find();

    return GetBuilder<ThemeController>(
      builder: (themeCon) {
        Color secondColor =
            themeCon.currentTheme == 'dark' ? AppColors.black : AppColors.white;
        return GestureDetector(
          onTap: () {
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
            decoration: BoxDecoration(
              color: themeCon.currentTheme == 'dark'
                  ? AppColors.white.withOpacity(0.99)
                  : AppColors.blue,
              borderRadius: const BorderRadius.only(
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
                          // QueryArtworkWidget(
                          //   id: data[controller.index].id,
                          //   type: ArtworkType.AUDIO,
                          //   size: 1000,
                          //   artworkFit: BoxFit.cover,
                          //   artworkQuality: FilterQuality.high,
                          //   artworkBorder: BorderRadius.circular(10),
                          //   nullArtworkWidget: const SizedBox(),
                          // ),
                          SizedBox(
                            width: AppDecoration().screenWidth * 0.135,
                            height: AppDecoration().screenHeight * 0.0565,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: listCon.hasImage[
                                      data[controller.index].id.toString()]!
                                  ? Image.file(
                                      File(
                                        '${myServices.appDocs.path}/${data[controller.index].title.replaceAll('/', '').replaceAll('\\', '').replaceAll('.', '').trim().replaceAll('_', '').replaceAll('-', '').replaceAll('|', '').replaceAll('(', '').replaceAll(')', '').replaceAll('@', '').replaceAll(' x ', '').removeAllWhitespace}.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          SizedBox(width: AppDecoration().screenWidth * 0.01),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              data[controller.index].title.toString().length >
                                      14
                                  ? data[controller.index]
                                      .title
                                      .toString()
                                      .substring(0, 14)
                                      .replaceRange(14, 14, '...')
                                  : data[controller.index].title.toString(),
                              style: TextStyle(
                                color: secondColor,
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
                                controller.previousButton();
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Icon(
                                  Icons.skip_previous_rounded,
                                  color: secondColor,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.playButton();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  controller.isPlaying == false
                                      ? Icons.play_circle
                                      : Icons.pause_circle,
                                  color: secondColor,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.nextButton();
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Icon(
                                  Icons.skip_next_rounded,
                                  color: secondColor,
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
      },
    );
  }
}
