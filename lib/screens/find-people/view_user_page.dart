import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/profile/edit_profile_page.dart';
import 'package:planago/screens/profile/profile_detail_page.dart';
import 'package:planago/screens/profile/profile_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/helper/converter.dart';

class ViewUserPage extends StatefulWidget {
  UserModel viewedUser;

  ViewUserPage({required this.viewedUser, super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  File? _imageFile;
  bool isPrivate = false;

  late List<ProfileInfo> profileItems;

  @override
  void initState() {
    super.initState();
    profileItems = [
      ProfileInfo(
        icon: Icons.phone,
        title: 'Phone',
        subtitle: widget.viewedUser.phoneNumber,
      ),
      ProfileInfo(
        icon: Icons.email,
        title: 'Email',
        subtitle: widget.viewedUser.email,
      ),
      ProfileInfo(
        icon: Icons.favorite,
        title: 'Interests',
        subtitle:
            widget.viewedUser.interests.isNotEmpty
                ? widget.viewedUser.interests.join(', ')
                : 'No Interests',
      ),
      ProfileInfo(
        icon: Icons.flight_takeoff,
        title: 'Travel Styles',
        subtitle:
            widget.viewedUser.travelStyle.isNotEmpty
                ? widget.viewedUser.travelStyle.join(', ')
                : 'No Travel Styles',
      ),
    ];
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
          padding: EdgeInsets.only(
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
          ),
          child: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.05),
            child: Column(
              children: [
                headButtons(screenWidth, screenHeight),
                profilePicture(screenWidth, screenHeight, widget.viewedUser.avatar),
                profileInfo(screenWidth, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileInfo(double width, double height) {
    return ListView.builder(
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
    return SizedBox(
      width: width * 0.88,
      height: height * 0.0585,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox.square(
            dimension: height * 0.0504,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: AppColors.primary),
              iconSize: height * 0.03,
            ),
          ),
          followingButton(width, height),
        ],
      ),
    );
  }

  Obx followingButton(double screenWidth, double screenHeight) {
    return Obx(() {
      final followed = UserController.instance.user.value.following.contains(
        widget.viewedUser.username,
      );
      print(UserController.instance.user.value.following);
      return GestureDetector(
        onTap: () async {
          if (followed) {
            await UserController.instance.unfollowUser(widget.viewedUser);
            print("Unfollow");
          } else {
            await UserController.instance.followUser(widget.viewedUser);
            print("Follow");
          }
        },
        child: AnimatedContainer(
          height: screenHeight * 0.036,
          width: screenWidth * 0.23,
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: followed ? AppColors.primary : AppColors.mutedPrimary,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: followed ? Colors.transparent : AppColors.mutedPrimary,
            ),
          ),
          child: Center(
            child: Text(
              followed ? 'Following' : 'Follow',
              style: TextStyle(
                color: followed ? AppColors.mutedWhite : AppColors.mutedBlack,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget profilePicture(double width, double height, String image) {
    return SizedBox(
      width: width * 0.88,
      height: height * 0.1828, //updated height val
      child: Column(
        children: [
          SizedBox.square(
            dimension: height * 0.1169, //102
            child: ClipOval(
              child: AppConvert.isBase64(image)
                                ? Image.memory(
                                  base64Decode(image),
                                  fit: BoxFit.cover,
                                )
                                : Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Image.asset(
                                        'assets/images/default_profile.png',
                                        fit: BoxFit.cover,
                                      ),
                                ),
            ),
          ),
          // spacing between profile pic and texts
          SizedBox(width: width * 0.88, height: height * 0.01),
          Text(
            "${widget.viewedUser.firstName} ${widget.viewedUser.lastName}",
            style: TextStyle(
              color: AppColors.black,
              fontSize: height * 0.0183,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.viewedUser.username,
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
}
