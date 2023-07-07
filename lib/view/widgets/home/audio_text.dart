import 'package:flutter/material.dart';

class AudioText extends StatelessWidget {
  const AudioText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0, bottom: 4),
      child: Text(
        'Audio',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: 'Cairo',
          height: 1.7,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
