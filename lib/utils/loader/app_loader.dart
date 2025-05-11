import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/loader/animation_loader.dart';

class AppLoader {



  static void openLoadingDialog(String message, String animation) {
    showDialog(context: Get.overlayContext!, 
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Container(
        color: AppColors.mutedWhite,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 250),
            AnimationLoader(text: message, animation: animation),
          ],
        ),
      )
    ));
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}