import 'package:audio_app/controller/art_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentAudio extends StatelessWidget {
  const CurrentAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArtWork>(
      builder: (controller) {
        return controller.currentAudio ?? const SizedBox();
      },
    );
  }
}
