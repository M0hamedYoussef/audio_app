import 'package:audio_app/controller/list_con.dart';
import 'package:audio_app/view/widgets/home/audio_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class AudioList extends StatelessWidget {
  const AudioList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListCon>(
      builder: (controller) {
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
                      if (controller.dataFuture[index].displayName
                          .toLowerCase()
                          .contains(controller.searchCon.text.toLowerCase()))
                        AudioTile(
                          currentIndex: index,
                          data: controller.dataFuture,
                        ),
                      if (controller.dataFuture[index].displayName
                          .toLowerCase()
                          .contains(controller.searchCon.text.toLowerCase()))
                        const Divider(),
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
                    const Divider(),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
