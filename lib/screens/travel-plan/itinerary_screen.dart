/*
In travel_overview_page.dart look for the following code snippet:


  onPressed: () 
  {
    //fix this. dapat hindi gagawa ng panibagong instantance ng itinerary if pipindutin ulit ang existing itinerary.
    Get.to(() => ItineraryScreen(plan: plan));
  },
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/utils/constants/colors.dart';
import '/controllers/itinerary_controller.dart';
import '../tabs/destinations_tab.dart';
import '../tabs/activities_tab.dart';
import '../tabs/expenses_tab.dart';

class ItineraryScreen extends StatefulWidget {
  final TravelPlan plan;
  const ItineraryScreen({super.key, required this.plan});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final ItineraryController controller = Get.put(ItineraryController());

  @override
  void initState() {
    super.initState();
    if (widget.plan.startDate != null && widget.plan.endDate != null) {
      controller.setDurationFromDates(widget.plan.startDate!, widget.plan.endDate!);
    }
    controller.setTravelersFromPlan(widget.plan);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Get.back(),
          ),
          bottom: TabBar(
            onTap: controller.changeTab,
            indicatorColor: AppColors.primary,
            tabs: [
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
          children: [
            DestinationsTab(controller: controller),
            ActivitiesTab(controller: controller),
            ExpensesTab(controller: controller),
          ],
        ),
      ),
    );
  }
}