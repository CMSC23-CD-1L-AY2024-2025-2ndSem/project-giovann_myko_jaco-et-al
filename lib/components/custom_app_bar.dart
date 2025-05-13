import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class CustomAppBar extends StatelessWidget{
  const CustomAppBar({super.key});


  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;

    return Obx(() => SafeArea(child: 
    Container(
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
                  child: SizedBox.square(
                    dimension: width * 0.12,
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
                  height: height * 0.02,
                  child: Text("Good day!",
                    style: TextStyle(
                      fontSize: height * 0.017,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Text(UserController.instance.user.value.firstName,
                  style: TextStyle(
                    fontSize: height * 0.022,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            )
              ],
            ),
            //Notification Icon
            SizedBox.square(
            dimension: width * 0.12,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: Colors.transparent),
                backgroundColor: Color.fromRGBO(227, 247, 255, 1),
              ),
              onPressed: () {
                
              },
              child: Icon(
                Iconsax.notification4,
                color: AppColors.primary,
                size: width * 0.055,
              ),
            ),
          ),
          ],
        ),
      ),
    )
    ));
  }
}