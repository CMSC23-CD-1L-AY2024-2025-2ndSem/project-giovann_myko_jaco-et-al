import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/components/app_bar_return.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ChooseAvatarPage extends StatefulWidget {
  const ChooseAvatarPage({super.key});

  @override
  State<ChooseAvatarPage> createState() => _ChooseAvatarPageState();
}

class _ChooseAvatarPageState extends State<ChooseAvatarPage> {
  final Rx<String> avatar = "".obs;
  final selectedAvatarIndex = (-1).obs;

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () => Get.back(),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.only(left: 9, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Select an ",
                          style: TextStyle(
                            fontSize: screenHeight * 0.0401,
                            fontFamily: 'Cal Sans',
                            color: AppColors.black,
                          ),
                        ),
                        GradientText(
                          "Avatar",
                          style: TextStyle(
                            fontSize: screenHeight * 0.0401,
                            fontFamily: 'Cal Sans',
                          ),
                          colors: [AppColors.primary, AppColors.secondary],
                          gradientType: GradientType.linear,
                          gradientDirection: GradientDirection.ltr,
                        ),
                      ],
                    ),
                    Text(
                      "This will be represent your picture on your profile!\nYou can update this later!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        fontSize: screenHeight * 0.015,
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar Grid (Flexible area)
              Expanded(
                child: Obx(
                  () => GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: screenWidth * 0.04,
                    mainAxisSpacing: screenHeight * 0.02,
                    children: List.generate(
                      AppImages.avatars.length,
                      (index) => buildAvatar(
                        AppImages.avatars[index],
                        screenWidth,
                        index,
                        selectedAvatarIndex.value == index,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0),
                child: SizedBox(
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.0527,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: OutlinedButton(
                      onPressed: () async {
                        final userDetails = UserController.instance.user;
                        final base64avatar =
                            await AppConvert.convertAssetToBase64(avatar.value);
                        final user = userDetails.value.copyWith(
                          avatar: base64avatar,
                        );

                        final controller = UserController.instance;
                        controller.editUserProfile(user);

                        Get.back();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          letterSpacing: -0.5,
                          color: AppColors.mutedWhite,
                          fontSize: screenHeight * 0.023,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAvatar(String image, double width, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        selectedAvatarIndex.value = index;
        avatar.value = image;
        print(avatar.value);
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          border:
              isSelected
                  ? Border.all(color: Colors.transparent, width: 2)
                  : null,
        ),
        child: ClipOval(
          child: Image.asset(
            image,
            width: width * 0.18,
            height: width * 0.18,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
