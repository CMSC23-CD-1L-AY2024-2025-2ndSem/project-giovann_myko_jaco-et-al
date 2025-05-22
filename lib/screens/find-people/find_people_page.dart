import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/components/search_user_delegate.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/screens/find-people/view_user_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';

class FindPeoplePage extends StatefulWidget {
  const FindPeoplePage({super.key});

  @override
  State<FindPeoplePage> createState() => _FindPeoplePageState();
}

class _FindPeoplePageState extends State<FindPeoplePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await UserController.instance.fetchUserData();
    await UserController.instance.fetchSimilarUsers();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      final userController = UserController.instance;
      final similarUsers = userController.similarUsers;

      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.031,
          ),
          child: Column(
            children: [
              _SearchBar(screenHeight: screenHeight, screenWidth: screenWidth),
              Expanded(
                child: similarUsers.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: screenHeight * 0.015),
                        itemCount: similarUsers.length,
                        itemBuilder: (context, index) {
                          return _UserTile(
                            user: similarUsers[index],
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No users found",
                          style: TextStyle(color: AppColors.mutedBlack),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SearchBar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const _SearchBar({
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.05,
      child: TextField(
        readOnly: true,
        onTap: () {
          showSearch(
            context: context,
            delegate: SearchUserDelegate(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          );
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.mutedPrimary,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search, color: AppColors.mutedBlack),
          hintText: "Search users",
          hintStyle: TextStyle(
            fontSize: screenHeight * 0.01727,
            color: AppColors.mutedBlack,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        cursorColor: AppColors.mutedBlack,
        cursorHeight: screenHeight * 0.02,
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final double screenWidth;
  final double screenHeight;

  const _UserTile({
    required this.user,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ViewUserPage(viewedUser: user)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _UserInfo(user: user, screenWidth: screenWidth, screenHeight: screenHeight),
            _FollowButton(user: user, screenWidth: screenWidth, screenHeight: screenHeight),
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final UserModel user;
  final double screenWidth;
  final double screenHeight;

  const _UserInfo({
    required this.user,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: screenHeight * 0.056,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: AppConvert.isBase64(user.avatar)
                                ? Image.memory(
                                  base64Decode(user.avatar),
                                  fit: BoxFit.cover,
                                )
                                : Image.network(
                                  user.avatar,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Image.asset(
                                        'assets/images/default_profile.png',
                                        fit: BoxFit.cover,
                                      ),
                                ),
          ),
        ),
        SizedBox(width: screenWidth * 0.015),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.firstName} ${user.lastName}",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: screenHeight * 0.015,
              ),
            ),
            Text(
              "@${user.username}",
              style: TextStyle(
                color: AppColors.gray,
                fontSize: screenHeight * 0.0138,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  final UserModel user;
  final double screenWidth;
  final double screenHeight;

  const _FollowButton({
    required this.user,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = UserController.instance;
      final isFollowing = controller.user.value.following.contains(user.username);

      return GestureDetector(
        onTap: () async {
          isFollowing
              ? await controller.unfollowUser(user)
              : await controller.followUser(user);
        },
        child: AnimatedContainer(
          height: screenHeight * 0.036,
          width: screenWidth * 0.23,
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isFollowing ? AppColors.primary : AppColors.mutedPrimary,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isFollowing ? Colors.transparent : AppColors.mutedPrimary,
            ),
          ),
          child: Center(
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: isFollowing ? AppColors.mutedWhite : AppColors.mutedBlack,
              ),
            ),
          ),
        ),
      );
    });
  }
}
