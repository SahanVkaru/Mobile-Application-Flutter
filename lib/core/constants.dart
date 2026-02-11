import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryBrown = Color(0xFF795548);
  static const Color alertRed = Color(0xFFD32F2F);
  static const Color syncAmber = Color(0xFFFFC107);
  static const Color background = Color(0xFFF1F8E9);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppStrings {
  static const String appName = 'TeaSmart';
  static const String hiveBoxName = 'tea_smart_box';
  
  // Storage Keys
  static const String keyWeightRecords = 'weight_records';
  static const String keySyncQueue = 'sync_queue';
  static const String keyUsers = 'users'; // For offline login
}

class AppAssets {
  static const String logoFactory = 'assets/logo_factory.png';
  static const String iconTeaSack = 'assets/icons/tea_sack.png';
  static const String soundSuccess = 'assets/sounds/success_beep.mp3';
}
