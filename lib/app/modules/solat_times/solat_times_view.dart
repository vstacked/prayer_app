import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prayer_app/app/utils/app_colors.dart';
import 'package:prayer_app/app/widgets/loading.dart';

import 'solat_times_controller.dart';

class SolatTimesView extends GetView<SolatTimesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solat Times', style: Get.textTheme.headline6.copyWith(color: mainColor)),
        leading: BackButton(color: mainColor),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(
        () {
          if (controller.isLoading) return const Loading();
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.location,
                      style: Get.textTheme.headline6.copyWith(color: mainColor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      controller.date,
                      style:
                          Get.textTheme.subtitle1.copyWith(color: mainColor, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Text(
                      "${controller.minutesToGo['title']} ${controller.minutesToGo['time']}",
                      style: Get.textTheme.headline4.copyWith(color: mainColor, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${controller.minutesToGo['diff']} minutes to go',
                      style: Get.textTheme.headline6.copyWith(color: mainColor),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.schedules.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (_, i) {
                  final schedule = controller.schedules.entries.toList()[i];
                  return Container(
                    height: 76,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: mainColorOp75),
                    padding: const EdgeInsets.symmetric(horizontal: 17.5),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            // TODO ICON
                            Icon(Icons.ac_unit, color: Colors.white),
                            const SizedBox(width: 18),
                            Text(
                              schedule.key,
                              style: Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                            )
                          ],
                        ),
                        const Spacer(),
                        Text(
                          schedule.value,
                          style: Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
