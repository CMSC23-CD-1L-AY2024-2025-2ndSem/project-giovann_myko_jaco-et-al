import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';

class TravelAppBar extends StatelessWidget {
  const TravelAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
          child: Image.asset(
            AppImages.mountains, // Replace with your header image
            width: double.infinity,
            height: height * 0.22,
            fit: BoxFit.cover,
          ),
        ),

        //Back button
        Positioned(
          top: width * 0.09,
          left: width * 0.05,
          child: CircleAvatar(
            backgroundColor: AppColors.mutedWhite,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed:
                  () => Get.offUntil(
                    MaterialPageRoute(builder: (_) => NavigationMenu()),
                    (route) => route.settings.name == '/navigation',
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
