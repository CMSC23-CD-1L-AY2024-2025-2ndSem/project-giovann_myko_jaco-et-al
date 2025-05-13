import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/components/custom_app_bar.dart';
import 'package:planago/screens/profile/profile_page.dart';
import 'package:planago/screens/travel_plan_page.dart';
import 'package:planago/utils/constants/colors.dart';

class NavigationMenu extends StatelessWidget 
{
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final controller = Get.put(NavigationController());

    return Scaffold(
      
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected:
              (index) => controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.people), label: "People"),
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => Column(
        children: [
          CustomAppBar(),
          controller.screens[controller.selectedIndex.value]
        ],
      )),
    );
  }
}

class NavigationController extends GetxController 
{
  final selectedIndex = 0.obs;

  final screens = 
  [
    Container(color: AppColors.primary),
    TravelPlanPage(),
    ProfilePage(),
  ];
}
