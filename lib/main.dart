import 'package:audio/binding/my_bind.dart';
import 'package:audio/core/services/my_services.dart';
import 'package:audio/view/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBind(),
      initialRoute: '/home',
      theme: myServices.themeData,
      getPages: [
        GetPage(name: '/home', page: () => const Home()),
      ],
    );
  }
}
