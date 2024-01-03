import 'package:audio/controller/audio_con.dart';
import 'package:audio/controller/list_con.dart';
import 'package:audio/controller/theme_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioTextRow extends StatelessWidget {
  const AudioTextRow({super.key});

  @override
  Widget build(BuildContext context) {
    ListCon listCon = Get.find();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4, right: 8.0),
      child: GetBuilder<ThemeController>(
        builder: (themeCon) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Audio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                      height: 1.7,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  IconButton(
                    onPressed: () {
                      themeCon.changeTheme();
                    },
                    icon: Icon(
                      themeCon.currentTheme == 'dark'
                          ? Icons.light_mode_sharp
                          : Icons.light_mode_outlined,
                      size: 25,
                    ),
                  ),
                ],
              ),
              GetBuilder<ListCon>(
                builder: (_) {
                  return Row(
                    children: [
                      if (!listCon.loading && !listCon.pl)
                        IconButton(
                          onPressed: () {
                            listCon.refreshList();
                          },
                          icon: const Icon(
                            Icons.refresh_rounded,
                            size: 27,
                          ),
                        ),
                        GetBuilder<AudioCon>(
                          builder: (controller) {
                            if (listCon.dataFuture.length <= 1 ||
                                listCon.loading == true ||
                                listCon.loadingPl == true) {
                              return const SizedBox();
                            } else {
                              return IconButton(
                                onPressed: () {
                                  controller.shuffle();
                                },
                                icon: Icon(
                                  Icons.shuffle,
                                  color: controller.shuffleMode == true
                                      ? AppColors.blue
                                      : themeCon.currentTheme == 'dark'
                                          ? AppColors.white
                                          : AppColors.black,
                                  size: 27,
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
