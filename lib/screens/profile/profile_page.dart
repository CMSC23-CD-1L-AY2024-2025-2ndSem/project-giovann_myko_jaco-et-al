import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/profile/edit_profile_page.dart';
import 'package:planago/screens/profile/profile_detail_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';
import 'package:planago/utils/helper/imagepicker.dart';
import 'package:planago/utils/loader/app_loader.dart';

// Temporary model
class ProfileInfo {
  final String title;
  final String subtitle;
  final IconData icon;

  ProfileInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final controller = UserController.instance;
  // Temporary variables habang wala pa data model + database
  bool isPrivate = false;

  late List<ProfileInfo> profileItems;

  @override
  void initState() {
    super.initState();
    // moved inside Obx
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mutedWhite,
      body: SingleChildScrollView(
        // Main Container for Profile Page
        child: Container(
          margin: EdgeInsets.only(
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            top: screenHeight * 0.05,
          ),
          child: Obx(() {
            profileItems = [
              ProfileInfo(
                icon: Icons.phone,
                title: 'Phone',
                subtitle: controller.user.value.phoneNumber,
              ),
              ProfileInfo(
                icon: Icons.email,
                title: 'Email',
                subtitle: controller.user.value.email,
              ),
              ProfileInfo(
                icon: Icons.favorite,
                title: 'Interests',
                subtitle:
                    controller.user.value.interests.isNotEmpty
                        ? controller.user.value.interests.join(', ')
                        : 'No Interests',
              ),
              ProfileInfo(
                icon: Icons.flight_takeoff,
                title: 'Travel Styles',
                subtitle:
                    controller.user.value.travelStyle.isNotEmpty
                        ? controller.user.value.travelStyle.join(', ')
                        : 'No Travel Styles',
              ),
            ];
            return Column(
              children: [
                headButtons(screenWidth, screenHeight),
                profilePicture(screenWidth, screenHeight),
                editProfile(screenWidth, screenHeight),
                signOutButton(screenWidth, screenHeight),
                profileInfo(screenWidth, screenHeight),
                Container(height: screenHeight * 0.1),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget profileInfo(double width, double height) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: profileItems.length,
      itemBuilder: (context, index) {
        final item = profileItems[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileDetailPage(item: item),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Rounded borders
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!.withValues(), // Light shadow
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item.icon, color: AppColors.primary),
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: Icon(Icons.arrow_forward, color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget headButtons(double width, double height) {
    final WidgetStateProperty<Icon> thumbIcon =
        WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
          WidgetState.selected: Icon(Iconsax.lock5, color: AppColors.black),
          WidgetState.any: Icon(
            Iconsax.global,
            color: AppColors.primaryComplement,
          ),
        });

    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color.fromRGBO(122, 215, 240, 0.6);
          }
          return Color.fromRGBO(30, 30, 30, 0.4);
        });

    final WidgetStateProperty<Color?> thumbColor =
        WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.black;
        });

    final WidgetStateProperty<Color?> trackColor =
        WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.black;
          }
          return AppColors.primary;
        });

    final WidgetStateProperty<Color?> trackOutlineColor =
        WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.black;
          }
          return AppColors.primary;
        });

    return SizedBox(
      width: width * 0.88,
      height: height * 0.0585,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.scale(
            // make slider bigger
            scale: 1.2,
            child: Switch(
              value: UserController.instance.user.value.isPrivate,
              trackOutlineColor: trackOutlineColor,
              trackColor: trackColor,
              overlayColor: overlayColor,
              thumbColor: thumbColor,
              thumbIcon: thumbIcon,
              onChanged: (value) {
                final state = UserController.instance.user.value.copyWith(
                  isPrivate: value,
                );
                final controller = UserController.instance;
                controller.editUserProfile(state);
              },
            ),
          ),
          SizedBox.square(
            dimension: height * 0.0504,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: Colors.transparent),
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {},
              child: Icon(Iconsax.notification5, color: AppColors.mutedWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget profilePicture(double width, double height) {
    return SizedBox(
      width: width * 0.88,
      height: height * 0.1828, //updated height val
      child: Column(
        children: [
          GestureDetector(
            onTap: () => ImagePickerUtil.pickProfileImage(context),
            child: SizedBox.square(
              dimension: height * 0.1169, //102
              child: ClipOval(
                child: Image.memory(
                  AppConvert.base64toImage(
                    UserController.instance.user.value.avatar,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // spacing between profile pic and texts
          SizedBox(width: width * 0.88, height: height * 0.01),
          Text(
            "${controller.user.value.firstName} ${controller.user.value.lastName}",
            style: TextStyle(
              color: AppColors.black,
              fontSize: height * 0.0183,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            controller.user.value.username,
            style: TextStyle(
              color: Color.fromARGB(255, 82, 82, 82),
              fontSize: height * 0.0105, //temporarily 105
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  //Sign out button
  Widget signOutButton(double width, double height) {
    return SizedBox(
      width: width * 0.88,
      height: height * 0.0258,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.logout, color: AppColors.primary, size: height * 0.0225),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            ),
            onPressed: () async {
              //Start loading animation
              AppLoader.openLoadingDialog(
                "Logging you out...",
                AppImages.docerAnimation,
              );
              await AuthenticationController.instance.signOut();
              AppLoader.stopLoading();
              await AuthenticationController.instance.screenRedirect();
              NavigationController.instance.selectedIndex.value = 1;
              print("User logged out successfully");
            },
            child: Text(
              "Sign Out",
              style: TextStyle(
                fontFamily: "Cal Sans",
                color: AppColors.primary,
                fontSize: height * 0.018,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editProfile(double width, double height) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01),
      width: width * 0.88,
      height: height * 0.0258,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.edit, color: AppColors.primary, size: height * 0.0225),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            ),
            onPressed: () async {
              Get.to(() => EditProfilePage());
            },
            child: Text(
              "Edit Profile",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: height * 0.018,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
