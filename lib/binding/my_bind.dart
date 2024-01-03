import 'package:audio/controller/art_con.dart';
import 'package:audio/controller/audio_con.dart';
import 'package:audio/controller/list_con.dart';
import 'package:get/get.dart';

class MyBind implements Bindings {
  @override
  void dependencies() {
    Get.put(ArtWork());
    Get.put(ListCon());
    Get.put(AudioCon());
  }
}
