import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/components/custom_app_bar.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/screens/profile/find_people_page.dart';
import 'package:planago/screens/profile/profile_page.dart';
import 'package:planago/screens/travel-plan/travel_plan_page.dart';
import 'package:planago/utils/constants/colors.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Removes tap splash
          highlightColor: Colors.transparent, // Removes highlight on press
          hoverColor: Colors.transparent, // (Optional) for desktop/web
        ),
        child: Obx(
          () => BottomNavigationBar(
            elevation: 0,
            iconSize: width * 0.085,
            backgroundColor: AppColors.mutedWhite,
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.gray,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            enableFeedback: false,
            selectedIconTheme: IconThemeData(
              color: AppColors.primary,
              size: width * 0.095,
            ),
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              controller.selectedIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded),
                label: 'People',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.luggage_rounded),
                label: 'Travel Plan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final selectedIndex = 1.obs;
  final screens = [
    const FindPeoplePage(),
    const TravelPlanPage(),
    ProfilePage(),
  ];
}
