import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListCon extends GetxController {
  OnAudioQuery onAudio = OnAudioQuery();
  List<SongModel> dataFuture = [];
  bool search = false;
  TextEditingController searchCon = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String lastSearch = '';

  @override
  Future<void> onInit() async {
    super.onInit();
    dataFuture = await onAudio.querySongs(
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
      orderType: OrderType.DESC_OR_GREATER,
    );
    update();
  }

  searchCompleted() {
    if (lastSearch != searchCon.text) {
      lastSearch = searchCon.text;
      search = true;
      update();
    }
  }

  Future<bool> exitSearch() {
    search = false;
    searchFocus.unfocus();
    searchCon.clear();
    update();
    return Future.value(false);
  }
}
