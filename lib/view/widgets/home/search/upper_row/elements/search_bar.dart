import 'package:audio/controller/lang_con.dart';
import 'package:audio/controller/list_con.dart';
import 'package:audio/controller/theme_con.dart';
import 'package:audio/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBar extends GetView<ListCon> {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LangCon());
    ThemeController themeController = Get.put(ThemeController());
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: themeController.currentTheme == 'dark'
                ? AppColors.black.withOpacity(0.5)
                : AppColors.greyDesign,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.fromLTRB(5, 10, 18, 5),
          child: GetBuilder<LangCon>(
            builder: (langCon) => TextFormField(
              textDirection: langCon.langTextField == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              controller: controller.searchCon,
              focusNode: controller.searchFocus,
              onChanged: (value) {
                langCon.checkTextLang(value);
                controller.searching();
              },
              onTapOutside: (event) {
                controller.searchFocus.unfocus();
              },
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 9, horizontal: 27),
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
        );
      },
    );
  }
}
