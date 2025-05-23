import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/screens/find-people/view_user_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/helper/converter.dart';

class SearchTripmateDelegate extends SearchDelegate {
  final double screenHeight;
  final double screenWidth;

  SearchTripmateDelegate({
    required this.screenHeight,
    required this.screenWidth,
    required this.plan,
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
    return Obx(() {
      final suggestions =
          TravelPlanDatabase.instance.tripmateSuggestion
              .where(
                (user) =>
                    user.firstName.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    user.lastName.toLowerCase().contains(query.toLowerCase()) ||
                    user.username.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

      if (suggestions.isEmpty) {
        return Center(child: Text("No users found"));
      }

      return ListView.builder(
        padding: EdgeInsets.only(top: screenHeight * 0.013),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final user = suggestions[index];
          return userComponent(user, screenWidth, screenHeight);
        },
      );
    });
  }

  final TravelPlan plan;

  @override
  Widget buildSuggestions(BuildContext context) {
    return Obx(() {
      final suggestions =
          TravelPlanDatabase.instance.tripmateSuggestion
              .where(
                (user) =>
                    user.firstName.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    user.lastName.toLowerCase().contains(query.toLowerCase()) ||
                    user.username.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

      if (suggestions.isEmpty) {
        return Center(child: Text("No users found"));
      }

      return ListView.builder(
        padding: EdgeInsets.only(top: screenHeight * 0.013),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final user = suggestions[index];
          return userComponent(user, screenWidth, screenHeight);
        },
      );
    });
  }

  // same with find people page w/o follow button
  userComponent(UserModel user, double screenWidth, double screenHeight) {
    final RxList<String> reactivePeople = RxList<String>.from(
      plan.people ?? [],
    );

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
                    child:
                        AppConvert.isBase64(user.avatar)
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
                        fontWeight: FontWeight.normal,
                        fontSize: screenHeight * 0.0138,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Obx(() {
              final bool isCreator =
                  AuthenticationController.instance.authUser?.uid ==
                  plan.creator;
              final bool isInPlan = reactivePeople.contains(user.uid);
              final bool isViewingCreator = user.uid == plan.creator;

              // Disable button if not creator
              final bool isButtonEnabled = isCreator;

              // Define button label
              String buttonLabel;
              if (isCreator) {
                buttonLabel = isInPlan ? 'Remove' : 'Add';
              } else {
                buttonLabel =
                    isViewingCreator ? 'Creator' : (isInPlan ? 'Added' : 'Add');
              }

              return GestureDetector(
                onTap:
                    isButtonEnabled
                        ? () async {
                          if (isInPlan) {
                            await TravelPlanDatabase.instance
                                .removePersonFromPlan(plan.id!, user.uid);
                            reactivePeople.remove(user.uid);
                          } else {
                            await TravelPlanDatabase.instance.addPersonToPlan(
                              plan.id!,
                              user.uid,
                            );
                            reactivePeople.add(user.uid);
                          }

                          plan.people = reactivePeople.toList();
                          await TravelPlanDatabase.instance.getTripSuggestions(
                            plan,
                          );
                        }
                        : null,
                child: AnimatedContainer(
                  height: screenHeight * 0.036,
                  width: screenWidth * 0.23,
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color:
                        isButtonEnabled
                            ? (isInPlan
                                ? AppColors.primary
                                : AppColors.mutedPrimary)
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color:
                          isButtonEnabled
                              ? (isInPlan
                                  ? Colors.transparent
                                  : AppColors.mutedPrimary)
                              : Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      buttonLabel,
                      style: TextStyle(
                        color:
                            isButtonEnabled
                                ? (isInPlan
                                    ? AppColors.mutedWhite
                                    : AppColors.mutedBlack)
                                : Colors.grey,
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
