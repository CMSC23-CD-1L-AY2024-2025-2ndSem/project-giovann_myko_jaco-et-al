import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
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
    await UserController.instance
        .fetchSimilarUsers();
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
            vertical: screenHeight * 0.06,
          ),
          child: Column(
            children: [
              searchBar(screenWidth, screenHeight),
              Container(
                child:
                    similarUsers.isNotEmpty
                        ? Expanded(
                          child: ListView.builder(
                            itemCount: similarUsers.length,
                            itemBuilder: (context, index) {
                              return userComponent(
                                similarUsers[index],
                                screenWidth,
                                screenHeight,
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

  Widget searchBar(double screenWidth, double screenHeight) {
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
        onChanged: (value) => onSearch(value),
      ),
    );
  }

  bool isFollowedByMe(UserModel otherUser) {
    final following = UserController.instance.user.value.following;
    if (following.contains(otherUser.username)) {
      return true;
    }

    return false;
  }

  // template from: https://github.com/afgprogrammer/Flutter-searchable-listview/blob/master/lib/main.dart
  userComponent(UserModel user, double screenWidth, double screenHeight) {
    final followed = isFollowedByMe(user);

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: screenHeight * 0.076,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    AppImages.defaultProfile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "@${user.username}",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (followed) {
                await UserController.instance.unfollowUser(user);
              } else {
                await UserController.instance.followUser(user);
              }
            },
            child: AnimatedContainer(
              height: 35,
              width: 110,
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: followed ? Colors.blue[700] : Color(0xffffff),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: followed ? Colors.transparent : Colors.grey.shade700,
                ),
              ),
              child: Center(
                child: Text(
                  followed ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                    color: followed ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
