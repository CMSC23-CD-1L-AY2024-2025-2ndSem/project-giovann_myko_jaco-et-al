import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:planago/components/search_user_delegate.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/screens/profile/view_user_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';

class FindPeoplePage extends StatefulWidget {
  const FindPeoplePage({super.key});

  @override
  State<FindPeoplePage> createState() => _FindPeoplePageState();
}

class _FindPeoplePageState extends State<FindPeoplePage> {
  /*
    1. user list
    2. FoundUser list
    3. initState foundUser
  */

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
      final user = UserController.instance;
      final similarUsers = user.similarUsers;

      return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.031,
          ),
          child: Column(
            children: [
              searchBar(screenWidth, screenHeight, context),
              Container(
                child:
                    similarUsers.isNotEmpty
                        ? Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: screenHeight * 0.015),
                            itemCount: similarUsers.length,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => userComponent(
                                  similarUsers[index],
                                  screenWidth,
                                  screenHeight,
                                ),
                              );
                            },
                          ),
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

  onSearch(String item) {
    setState(() {});
  }

  Widget searchBar(
    double screenWidth,
    double screenHeight,
    BuildContext context,
  ) {
    return SizedBox(
      height: screenHeight * 0.05,
      child: TextField(
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
      ),
    );
  }

  // template from: https://github.com/afgprogrammer/Flutter-searchable-listview/blob/master/lib/main.dart
  userComponent(UserModel user, double screenWidth, double screenHeight) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.to(() => ViewUserPage(viewedUser: user)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: screenHeight * 0.056,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      AppImages.defaultProfile,
                      fit: BoxFit.cover,
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
                        fontWeight: FontWeight.normal,
                        fontSize: screenHeight * 0.0138,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Obx(() {
              final followed = UserController.instance.user.value.following
                  .contains(user.username);
              print(UserController.instance.user.value.following);
              return GestureDetector(
                onTap: () async {
                  if (followed) {
                    await UserController.instance.unfollowUser(user);
                    print("Unfollow");
                  } else {
                    await UserController.instance.followUser(user);
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
                      color:
                          followed ? Colors.transparent : AppColors.mutedPrimary,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      followed ? 'Following' : 'Follow',
                      style: TextStyle(
                        color:
                            followed
                                ? AppColors.mutedWhite
                                : AppColors.mutedBlack,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
