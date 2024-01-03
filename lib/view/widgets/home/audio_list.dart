import 'package:audio/controller/list_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/core/const/decoration.dart';
import 'package:audio/view/widgets/home/audio_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioList extends StatelessWidget {
  const AudioList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListCon>(
      builder: (controller) {
        if (controller.loading) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: AppDecoration().screenHeight * 0.05),
                SizedBox(height: AppDecoration().screenHeight * 0.2),
                const CircularProgressIndicator(
                  color: AppColors.grey,
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.02),
                Text(
                  controller.firstTime
                      ? 'It Take A While For First Time..'
                      : 'Scanning Media..',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: AppDecoration().screenHeight * 0.01),
                Text(
                  '${controller.audioList.length} / ${controller.dataFuture.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        } else if (controller.loadingPl) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.grey,
              ),
            ),
          );
        } else {
          if (controller.search) {
            return WillPopScope(
              onWillPop: controller.exitSearch,
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: controller.dataFuture.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        if (controller.dataFuture[index]
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
                            .contains(
                              controller.searchCon.text
                                  .toLowerCase()
                                  .trim()
                                  .replaceAll('_', '')
                                  .replaceAll('-', '')
                                  .replaceAll('|', '')
                                  .replaceAll('(', '')
                                  .replaceAll(')', '')
                                  .replaceAll('@', '')
                                  .replaceAll(' x ', '')
                                  .removeAllWhitespace,
                            ))
                          AudioTile(
                            currentIndex: index,
                            data: controller.dataFuture,
                          ),
                        if (controller.dataFuture[index]
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
                            .contains(
                              controller.searchCon.text
                                  .toLowerCase()
                                  .trim()
                                  .replaceAll('_', '')
                                  .replaceAll('-', '')
                                  .replaceAll('|', '')
                                  .replaceAll('(', '')
                                  .replaceAll(')', '')
                                  .replaceAll('@', '')
                                  .replaceAll(' x ', '')
                                  .removeAllWhitespace,
                            ))
                          const Divider(thickness: 0.2),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: controller.dataFuture.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      AudioTile(
                        currentIndex: index,
                        data: controller.dataFuture,
                      ),
                      const Divider(thickness: 0.2),
                    ],
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
