import 'package:audio_app/controller/art_con.dart';
import 'package:audio_app/controller/audio_con.dart';
import 'package:audio_app/controller/list_con.dart';
import 'package:get/get.dart';

class MyBind implements Bindings {
  @override
  void dependencies() {
    Get.put(ArtWork());
    Get.put(AudioCon());
    Get.put(ListCon());
  }
}
