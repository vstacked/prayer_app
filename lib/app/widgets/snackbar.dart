import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar({String title, String message, Color color}) => Get.snackbar(
      title ?? 'Request Timeout',
      message ?? 'Please try again..',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color ?? Colors.red[400],
      margin: EdgeInsets.zero,
      borderRadius: 0,
      isDismissible: false,
      colorText: Colors.white,
    );
