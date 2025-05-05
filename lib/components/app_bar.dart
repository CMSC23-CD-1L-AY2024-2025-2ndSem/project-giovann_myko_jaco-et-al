import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AppBarReturn extends StatelessWidget {
  const AppBarReturn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.mutedWhite),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: Color(0xffF5FCFF),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GradientText(
              "PlanaGo",
              style: TextStyle(fontSize: Get.height * 0.027, fontFamily: 'Cal Sans'),
              colors: [AppColors.primary, AppColors.secondary],
              gradientType: GradientType.linear,
              gradientDirection: GradientDirection.ltr,
                        ),
            )
          ],
        ),
      ),
    );
  }
}
