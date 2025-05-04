 

 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppDeviceUtils 
{

  static void hideKeyboard(BuildContext context)
  {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<void> setStatusBarColor(Color color) async 
  {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color
      )
    ); 
  }

  static double getStatusBarHeight()
  {
    return MediaQuery.of(Get.context!).padding.top;
  }

  static double getBottomNavigationBarHeight()
  {
    return kBottomNavigationBarHeight;
  }



 }