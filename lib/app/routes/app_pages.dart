import 'package:get/get.dart';

import 'package:prayer_app/app/modules/home/home_binding.dart';
import 'package:prayer_app/app/modules/home/home_view.dart';
import 'package:prayer_app/app/modules/solat_times/solat_times_binding.dart';
import 'package:prayer_app/app/modules/solat_times/solat_times_view.dart';
import 'package:prayer_app/app/modules/surah/surah_binding.dart';
import 'package:prayer_app/app/modules/surah/surah_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SURAH,
      page: () => SurahView(),
      binding: SurahBinding(),
    ),
    GetPage(
      name: _Paths.SOLAT_TIMES,
      page: () => SolatTimesView(),
      binding: SolatTimesBinding(),
    ),
  ];
}
