import 'package:audio_app/view/widgets/home/audio_list.dart';
import 'package:audio_app/view/widgets/home/audio_text.dart';
import 'package:audio_app/view/widgets/home/running_audio.dart';
import 'package:audio_app/view/widgets/home/search/upper_row/upper_row.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            UpperRow(),
            AudioText(),
            AudioList(),
            CurrentAudio(),
          ],
        ),
      ),
    );
  }
}
