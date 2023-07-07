import 'package:audio_app/controller/lang_con.dart';
import 'package:audio_app/controller/list_con.dart';
import 'package:audio_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBar extends GetView<ListCon> {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LangCon());
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyDesign,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GetBuilder<LangCon>(
          builder: (langCon) => TextFormField(
            textDirection: langCon.langTextField == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            controller: controller.searchCon,
            focusNode: controller.searchFocus,
            onEditingComplete: () {
              controller.searchCompleted();
            },
            onChanged: (value) {
              langCon.checkTextLang(value);
            },
            decoration: const InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 27),
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'Cairo',
                height: 1.7,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
