import 'package:audio/controller/list_con.dart';
import 'package:audio/view/widgets/home/audio_list.dart';
import 'package:audio/view/widgets/home/audio_text_row.dart';
import 'package:audio/view/widgets/home/running_audio.dart';
import 'package:audio/view/widgets/home/search/upper_row/upper_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends GetView<ListCon> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UpperRow(),
            const AudioTextRow(),
            const AudioList(),
            GetBuilder<ListCon>(
              builder: (_) {
                return Offstage(
                  offstage: controller.loading,
                  child: const CurrentAudio(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
