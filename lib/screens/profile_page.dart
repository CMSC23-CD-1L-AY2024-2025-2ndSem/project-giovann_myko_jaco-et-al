import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/utils/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Temporary variables habang wala pa data model + database
  bool isPrivate = false;
  String fullName = 'Lorem Ipsum';
  String username = '@loremlorem23';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mutedWhite,
      body: SingleChildScrollView(
        // Main Container for Profile Page
        child: Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
          ),
          child: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.05),
            child: Column(
              children: [
                headButtons(screenWidth, screenHeight),
                profilePicture(screenWidth, screenHeight),
                editProfile(screenWidth, screenHeight),
              ],
            ),
          ),
        ),
      ),
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
              value: isPrivate,
              trackOutlineColor: trackOutlineColor,
              trackColor: trackColor,
              overlayColor: overlayColor,
              thumbColor: thumbColor,
              thumbIcon: thumbIcon,
              onChanged: (value) {
                setState(() {
                  isPrivate = value;
                });
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
      height: height * 0.1828, //142
      child: Column(
        children: [
          SizedBox.square(
            dimension: height * 0.1169, //102
            child: ClipOval(
              child: Image.asset(
                'assets/images/default_profile.png',
              ), // temp only
            ),
          ),
          // spacing between profile pic and texts
          SizedBox(width: width * 0.88, height: height * 0.01),
          Text(
            fullName,
            style: TextStyle(
              color: AppColors.black,
              fontSize: height * 0.0183,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            username,
            style: TextStyle(
              color: Color.fromARGB(255, 82, 82, 82),
              fontSize: height * 0.0183,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget editProfile(double width, double height) {
    return SizedBox(
      width: width * 0.88,
      height: height * 0.0218,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.edit, color: AppColors.primary, size: height * 0.0195),
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {
              /* TO EDIT PAGE */
            },
            child: Text(
              "Edit Profile",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: height * 0.015,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
