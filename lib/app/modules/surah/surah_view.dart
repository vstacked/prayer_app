import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:prayer_app/app/modules/surah/detail_surah/detail_surah.dart';
import 'package:prayer_app/app/utils/app_colors.dart';
import 'package:prayer_app/app/widgets/loading.dart';

import 'surah_controller.dart';

class SurahView extends GetView<SurahController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah', style: Get.textTheme.headline6.copyWith(color: mainColor)),
        leading: BackButton(color: mainColor),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: Obx(() {
        if (controller.isScrolled)
          return FloatingActionButton(onPressed: controller.scrollToTop, child: const Icon(Icons.arrow_upward));
        return const SizedBox();
      }),
      body: Obx(
        () {
          if (controller.isErrorSurah) return const SizedBox();
          if (controller.surah.isEmpty) return Loading();
          return SingleChildScrollView(
            controller: controller.surahScrollController,
            child: Column(
              children: [
                const SizedBox(height: 25),
                _lastRead(),
                const SizedBox(height: 20),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.surah.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.5),
                    child: Divider(color: Colors.black.withOpacity(.25), height: 0),
                  ),
                  itemBuilder: (_, i) {
                    final surah = controller.surah[i];
                    return ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            surah.nomor,
                            style: Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      title: Text(
                        surah.nama,
                        style: Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        surah.arti,
                        style: Get.textTheme.subtitle2
                            .copyWith(fontWeight: FontWeight.normal, color: Colors.black.withOpacity(.5)),
                      ),
                      trailing: Text(
                        surah.asma,
                        style: Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600, color: mainColor),
                      ),
                      onTap: () {
                        controller.getAyat(i);
                        Get.to(
                          () => DetailSurah(
                            number: surah.nomor,
                            name: surah.nama,
                            meaning: surah.arti,
                            audio: surah.audio,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _lastRead() {
    return GestureDetector(
      onTap: () {
        controller.getAyat(0, isLastRead: true);
        Get.to(
          () => DetailSurah(
            number: controller.lastRead.nomor,
            name: controller.lastRead.nama,
            meaning: controller.lastRead.arti,
            audio: controller.lastRead.audio,
          ),
        );
      },
      child: Container(
        height: 130,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 33),
        decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.3),
                child: FaIcon(FontAwesomeIcons.quran, color: Colors.white.withOpacity(.5), size: 109),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.bookReader, color: Colors.white.withOpacity(.75)),
                      const SizedBox(width: 14.0),
                      Text(
                        'Last Read',
                        style: Get.textTheme.subtitle1
                            .copyWith(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.lastRead.nama ?? '',
                        style: Get.textTheme.bodyText1.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        controller.lastRead.arti ?? '',
                        style: Get.textTheme.caption.copyWith(color: Colors.white.withOpacity(.75)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
