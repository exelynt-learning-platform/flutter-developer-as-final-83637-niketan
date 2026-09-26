import 'package:employee_management/utils/shared_preferences/session.dart';
import 'package:flutter/material.dart';

class AppThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  static Future<void> initialize() async {
    final localStorage = LocalStorage();
    final isDark = await localStorage.getBool(localStorageKey: 'is_dark_mode') ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> toggle() async {
    final nextMode = themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = nextMode;

    final localStorage = LocalStorage();
    await localStorage.setBool(localStorageKey: 'is_dark_mode', value: nextMode == ThemeMode.dark);
  }
}
