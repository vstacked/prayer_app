import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:prayer_app/app/utils/app_colors.dart';
import 'package:prayer_app/app/widgets/loading.dart';

import '../surah_controller.dart';

class DetailSurah extends GetView<SurahController> {
  final String number;
  final String name;
  final String meaning;
  final String audio;

  const DetailSurah({this.number, this.name, this.meaning, this.audio});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.onBackPress(number);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(name, style: Get.textTheme.headline6.copyWith(color: mainColor)),
          leading: BackButton(
            color: mainColor,
            onPressed: () {
              controller.onBackPress(number);
            },
          ),
          actions: [
            Obx(
              () {
                if (!controller.hidePlayButton)
                  return Opacity(
                    opacity: controller.opacityPlayButton,
                    child: IconButton(
                      onPressed: controller.opacityPlayButton == 1 ? controller.playAudio : null,
                      icon: DecoratedBox(
                        decoration:
                            BoxDecoration(border: Border.all(color: mainColor, width: 2.0), shape: BoxShape.circle),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: controller.animationController,
                          color: mainColor,
                        ),
                      ),
                      iconSize: 30,
                    ),
                  );
                return const SizedBox();
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: backgroundColor,
        body: Obx(
          () {
            if (controller.isErrorDetail) return const SizedBox();
            if (controller.ayat.isEmpty) return Loading();

            return CustomScrollView(
              controller: controller.detailSurahScrollController,
              slivers: [
                _detailSurah(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final ayat = controller.ayat[i];
                      return ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ayat.nomor,
                              style: Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ayat.ar,
                          style: Get.textTheme.subtitle1
                              .copyWith(fontWeight: FontWeight.w600, color: mainColor, fontSize: 18),
                          textAlign: TextAlign.end,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Html(data: ayat.tr),
                            Text(
                              ayat.id,
                              style: Get.textTheme.bodyText2.copyWith(color: Colors.black.withOpacity(.5)),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: controller.ayat.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _detailSurah() {
    return SliverToBoxAdapter(
      child: Container(
        height: 130,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
        decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.3),
                child: FaIcon(FontAwesomeIcons.quran, color: Colors.white.withOpacity(.07), size: 109),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      number,
                      style: Get.textTheme.headline6.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Get.textTheme.bodyText1
                              .copyWith(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          meaning,
                          style: Get.textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(.75)),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!controller.hidePlayButton)
                    GestureDetector(
                      onTap: controller.playAudio,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white.withOpacity(.75),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: controller.animationController,
                          color: mainColor,
                          size: 45,
                        ),
                      ),
                    )
                  else
                    const CircleAvatar(radius: 35, backgroundColor: Colors.transparent),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
