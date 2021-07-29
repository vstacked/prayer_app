import 'package:get/get.dart';
import 'package:prayer_app/app/data/providers/surah_provider.dart';
import 'package:prayer_app/app/data/repositories/surah_repository.dart';

import 'surah_controller.dart';

class SurahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurahController>(
      () => SurahController(surahRepository: SurahRepository(SurahProvider())),
    );
  }
}
