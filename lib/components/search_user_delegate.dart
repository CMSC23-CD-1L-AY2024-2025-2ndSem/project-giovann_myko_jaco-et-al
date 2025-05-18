import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/screens/find-people/view_user_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';

class SearchUserDelegate extends SearchDelegate {
  final double screenHeight;
  final double screenWidth;
  final bool isSearchOnly;

  SearchUserDelegate({
    required this.screenHeight,
    required this.screenWidth,
    required this.isSearchOnly,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.mutedBlack,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.mutedPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Search users';

  @override
  TextStyle? get searchFieldStyle =>
      TextStyle(fontSize: screenHeight * 0.01727, color: AppColors.mutedBlack);

  // @override
  // InputDecorationTheme? get searchFieldDecorationTheme {
  //   return InputDecorationTheme(
  //     filled: true,
  //     fillColor: AppColors.mutedPrimary,
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(25),
  //       borderSide: BorderSide.none,
  //     ),
  //     contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
  //   );
  // }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
            UserController.instance.searchResults.clear();
          }
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    UserController.instance.onSearchChanged(query);

    if (!isSearchOnly) {
      final results = UserController.instance.searchResults;
      SearchTripController.instance.initToggles(results);
    }

    return Obx(() {
      final results = UserController.instance.searchResults;
      if (results.isEmpty) {
        return Center(child: Text("No users found"));
      }
      return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final user = results[index];
          return userComponent(user, screenWidth, screenHeight);
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    UserController.instance.onSearchChanged(query);

    if (!isSearchOnly) {
      final results = UserController.instance.searchResults;
      SearchTripController.instance.initToggles(results);
    }

    return Obx(() {
      final results = UserController.instance.searchResults;
      if (results.isEmpty) {
        return Center(child: Text("No users found"));
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: screenHeight * 0.013),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final user = results[index];
          return userComponent(user, screenWidth, screenHeight);
        },
      );
    });
  }

  // same with find people page w/o follow button
  userComponent(UserModel user, double screenWidth, double screenHeight) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.to(() => ViewUserPage(viewedUser: user)),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.06,
        ),
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
            // Reused same search delegate sa find people
            // nilagyan ko na lang bool to isolate button
            // temp controller check below
            !isSearchOnly
                ? Obx(() {
                  final toggled =
                      SearchTripController.instance
                          .getToggle(user.username)
                          .value;
                  return GestureDetector(
                    onTap: () {
                      SearchTripController.instance.toggle(user.username);
                    },
                    child: AnimatedContainer(
                      height: screenHeight * 0.036,
                      width: screenWidth * 0.23,
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color:
                            toggled
                                ? AppColors.primary
                                : AppColors.mutedPrimary,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color:
                              toggled
                                  ? Colors.transparent
                                  : AppColors.mutedPrimary,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          toggled ? 'Remove' : 'Add',
                          style: TextStyle(
                            color:
                                toggled
                                    ? AppColors.mutedWhite
                                    : AppColors.mutedBlack,
                          ),
                        ),
                      ),
                    ),
                  );
                })
                : Container(),
          ],
        ),
      ),
    );
  }
}

// TEMP CLASS FOR LOGIC ONLY
// REMOVE LATER
class SearchTripController extends GetxController {
  static SearchTripController get instance => Get.find();

  // Map of username -> toggle status
  // simulate storing lang para makita if nag
  // u-update/ work yung button
  final toggles = <String, RxBool>{};

  void initToggles(List<UserModel> users) {
    for (var user in users) {
      toggles.putIfAbsent(user.username, () => false.obs);
    }
  }

  void toggle(String username) {
    if (toggles.containsKey(username)) {
      // switch
      toggles[username]!.value = !toggles[username]!.value;
    }
  }

  RxBool getToggle(String username) {
    return toggles[username] ?? false.obs;
  }
}
