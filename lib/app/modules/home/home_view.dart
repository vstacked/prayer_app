import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:prayer_app/app/routes/app_pages.dart';
import 'package:prayer_app/app/utils/app_colors.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              print('about');
            },
            icon: Icon(Icons.info_outline, color: mainColor),
            iconSize: 25,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FaIcon(FontAwesomeIcons.mosque, color: mainColor, size: 115),
          Column(
            children: [
              _menu(
                icon: FontAwesomeIcons.quran,
                title: 'Al-Quran',
                onPress: () {
                  Get.toNamed(Routes.SURAH);
                },
              ),
              const SizedBox(height: 20),
              _menu(
                icon: Icons.schedule,
                title: 'Solat Times',
                onPress: () {
                  print('data2');
                },
              ),
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _menu({IconData icon, String title, VoidCallback onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(
              height: 66,
              width: 66,
              child: DecoratedBox(
                decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(7.5)),
                child: Center(child: FaIcon(icon, size: 36, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: Get.textTheme.headline6.copyWith(color: mainColor),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: mainColor),
          ],
        ),
      ),
    );
  }
}
