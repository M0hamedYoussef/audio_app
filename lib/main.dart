import 'package:audio_app/binding/my_bind.dart';
import 'package:audio_app/view/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBind(),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => const Home()),
      ],
    );
  }
}