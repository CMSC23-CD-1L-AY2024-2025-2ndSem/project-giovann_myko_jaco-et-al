import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/utils/constants/colors.dart';
import '/controllers/itinerary_controller.dart';
import '../tabs/destinations_tab.dart';
import '../tabs/activities_tab.dart';
import '../tabs/expenses_tab.dart';

class ItineraryScreen extends StatelessWidget 
{
  final ItineraryController controller = Get.put(ItineraryController());
  
  ItineraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          bottom: TabBar(
            onTap: controller.changeTab,
            indicatorColor: AppColors.primary,
            tabs: 
            [
              Tab(
                child: Obx(() => Text(
                  'Destination',
                  style: TextStyle(
                    color: controller.selectedTabIndex.value == 0 
                        ? AppColors.primary 
                        : Colors.grey,
                  ),
                )),
              ),
              Tab(
                child: Obx(() => Text(
                  'Daily Activities',
                  style: TextStyle(
                    color: controller.selectedTabIndex.value == 1 
                        ? AppColors.primary 
                        : Colors.grey,
                  ),
                )),
              ),
              Tab(
                child: Obx(() => Text(
                  'Expenses',
                  style: TextStyle(
                    color: controller.selectedTabIndex.value == 2 
                        ? AppColors.primary 
                        : Colors.grey,
                  ),
                )),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: 
          [
            DestinationsTab(),
            ActivitiesTab(),
            ExpensesTab(),
          ],
        ),
      ),
    );
  }
}