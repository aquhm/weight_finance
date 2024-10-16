// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ThemeController extends GetxController {
//   // _themeMode는 private으로 선언해서 외부에서 접근하지 못하게 함
//   final _themeMode = Rx<ThemeMode>(ThemeMode.system);
//
//   // getter를 통해 외부에서는 값을 읽을 수만 있게 함
//   ThemeMode get themeMode => _themeMode.value;
//
//   // 테마 변경 함수 (반드시 이 함수를 통해서만 값을 변경)
//   void toggleTheme(bool isDarkMode) {
//     _themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
//   }
//
//   // 시스템 테마로 변경하는 함수
//   void setSystemTheme() {
//     _themeMode.value = ThemeMode.system;
//   }
//
//   // 라이트 테마로 변경하는 함수
//   void setLightTheme() {
//     _themeMode.value = ThemeMode.light;
//   }
//
//   // 다크 테마로 변경하는 함수
//   void setDarkTheme() {
//     _themeMode.value = ThemeMode.dark;
//   }
// }
