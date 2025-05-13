import 'package:flutter/material.dart';

class AppColors 
{
  AppColors._();

  //Main App Colors
  static const Color primary = Color(0xff7ad7f0);
  static const Color secondary = Color(0xff1090c7);
  static const Color primaryComplement = Color(0xff92dff3);
  static const Color secondaryComplement = Color(0xffb7e9f7);
  static const Color muterPrimary = Color(0xffE3F7FF);

  //Text Colors
  static const Color black = Color.fromARGB(255, 30, 30, 30);
  static const Color mutedWhite = Color(0xfffafafa);
  static const Color gray = Color(0xff9B9B9C);



  //Gradient
  static const Gradient linearGradient = LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment(0, 100), end: Alignment(100, 0,)); 
}
