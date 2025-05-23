import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/firestore/itinerary_database.dart';
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
  void initState() 
  {
    super.initState();
    controller.setTravelersFromPlan(widget.plan);

    ItineraryDatabase.instance.getItinerary(widget.plan.id!).then((itinerary) {
      if (itinerary.isNotEmpty) {
        controller.setItinerary(itinerary);
      } else if (widget.plan.startDate != null && widget.plan.endDate != null) {
        // Only set duration and initialize if there is no existing itinerary
        controller.setDurationFromDates(widget.plan.startDate!, widget.plan.endDate!);
      }
    });
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.selectedTabIndex.value == 0
                        ? AppColors.primary
                        : Colors.grey,
                    fontSize: 12,
                  ),
                )),
              ),
              Tab(
                child: Obx(() => Text(
                  'Daily Activities',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.selectedTabIndex.value == 1
                        ? AppColors.primary
                        : Colors.grey,
                    fontSize: 12,
                  ),
                )),
              ),
              Tab(
                child: Obx(() => Text(
                  'Expenses',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
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
            DestinationsTab(controller: controller),
            ActivitiesTab(controller: controller),
            ExpensesTab(controller: controller),
          ],
        ),
      ),
    );
  }
}