import 'package:get/get.dart';
import 'package:prayer_app/app/data/providers/solat_provider.dart';
import 'package:prayer_app/app/data/repositories/solat_repository.dart';

import 'solat_times_controller.dart';

class SolatTimesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SolatTimesController>(
      () => SolatTimesController(solatRepository: SolatRepository(SolatProvider())),
    );
  }
}
