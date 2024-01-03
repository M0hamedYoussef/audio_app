import 'package:audio/core/services/my_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  MyServices myServices = Get.find();
  late String currentTheme;

  @override
  onInit() async {
    super.onInit();
    currentTheme = myServices.theme;
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (currentTheme == 'light') {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    } else if (currentTheme == 'dark') {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    }
  }

  changeTheme() async {
    if (currentTheme == 'light') {
      currentTheme = 'dark';
      Get.changeTheme(ThemeData.dark(
        useMaterial3: true,
      ));
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      currentTheme = 'light';
      Get.changeTheme(ThemeData.light(
        useMaterial3: true,
      ));
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }
    update();
    myServices.theme = currentTheme;
    await myServices.sharedPreferences.setString('theme', currentTheme);
  }
}
