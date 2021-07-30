import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prayer_app/app/utils/app_colors.dart';

import 'app/routes/app_pages.dart';

// TODO DEBUG ERRROR,
//* if music / surah / ayat null ?
//* debug hive
void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(accentColor: mainColor),
    ),
  );
}
