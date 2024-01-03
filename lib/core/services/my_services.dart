import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class MyServices extends GetxService {
  late Directory appDocs;
  late PermissionStatus status;
  late bool statusG;
  late SharedPreferences sharedPreferences;
  late String theme;
  late ThemeData themeData;
  late int androidVersion;

  Future<MyServices> init() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationIcon: 'mipmap/launcher_icon',
      androidNotificationOngoing: true,
    );

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getInt('androidVersion') == null) {
      AndroidDeviceInfo devInfo = await DeviceInfoPlugin().androidInfo;
      androidVersion = int.parse(devInfo.version.release.split('.')[0]);
      await sharedPreferences.setInt('androidVersion', androidVersion);
    } else {
      androidVersion = sharedPreferences.getInt('androidVersion')!;
    }

    if (androidVersion > 12) {
      status = await Permission.audio.request();
    } else {
      status = await Permission.storage.request();
    }

    theme = sharedPreferences.getString('theme') ?? 'light';

    if (status.isGranted) {
      statusG = true;
      if (sharedPreferences.getString('appDocs') == null) {
        appDocs = await getTemporaryDirectory();
        await sharedPreferences.setString('appDocs', appDocs.path);
      } else {
        appDocs = Directory(sharedPreferences.getString('appDocs')!);
      }
    } else {
      statusG = false;
    }
    themeData = theme == 'dark'
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return this;
  }
}

initServices() async {
  await Get.putAsync(() => MyServices().init());
}
