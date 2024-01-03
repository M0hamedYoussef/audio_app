import 'package:audio/controller/list_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:audio/view/widgets/home/search/upper_row/elements/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpperRow extends StatelessWidget {
  const UpperRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetBuilder<ListCon>(
          builder: (controller) {
            return Padding(
              padding: (controller.pl == false &&
                      controller.searchCon.text.trim().isEmpty)
                  ? const EdgeInsets.only(left: 13.0)
                  : const EdgeInsets.only(),
              child: Offstage(
                offstage: (controller.pl == false &&
                    controller.searchCon.text.trim().isEmpty),
                child: IconButton(
                  onPressed: () {
                    if (controller.pl) {
                      controller.removePlaylist();
                    } else {
                      controller.setPlaylist();
                    }
                  },
                  icon: Icon(
                    Icons.playlist_play,
                    color: controller.pl == true ? AppColors.blue : null,
                    size: 25,
                  ),
                ),
              ),
            );
          },
        ),
        const Expanded(
          child: SearchBar(),
        ),
      ],
    );
  }
}
