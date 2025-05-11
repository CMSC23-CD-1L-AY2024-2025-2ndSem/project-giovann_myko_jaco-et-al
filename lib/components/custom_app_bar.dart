import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class CustomAppBar extends StatelessWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: AppColors.mutedWhite,
        
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(onPressed: (){}, 
                icon: ClipOval(
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(
                      AppImages.defaultProfile,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
                SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 19,
                  child: Text("Good day!",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Text(UserController.instance.user.value.firstName,
                  style: TextStyle(
                    fontSize: 23,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}