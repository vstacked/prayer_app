import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:prayer_app/app/utils/app_colors.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle _style = Get.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w600, color: mainColor);
    return Scaffold(
      appBar: AppBar(
        title: Text('About', style: Get.textTheme.headline6.copyWith(color: mainColor)),
        leading: const BackButton(color: mainColor),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const FaIcon(FontAwesomeIcons.mosque, color: mainColor, size: 115),
            const SizedBox(height: 20),
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(children: [Text('Name', style: _style), Text(' : Prayer App', style: _style)]),
                TableRow(children: [Text('Version', style: _style), Text(' : 0.0.1', style: _style)])
              ],
            )
          ],
        ),
      ),
    );
  }
}
