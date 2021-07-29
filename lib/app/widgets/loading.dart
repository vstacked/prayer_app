import 'package:flutter/material.dart';
import 'package:prayer_app/app/utils/app_colors.dart';

class Loading extends StatelessWidget {
  final isCenterLoader;
  const Loading({Key key, this.isCenterLoader = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCenterLoader)
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor)));
    return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor));
  }
}
