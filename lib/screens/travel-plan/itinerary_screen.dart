import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/utils/constants/colors.dart';
import '/controllers/itinerary_controller.dart';
import '../tabs/destinations_tab.dart';
import '../tabs/activities_tab.dart';
import '../tabs/expenses_tab.dart';

class ItineraryScreen extends StatefulWidget 
{
  final TravelPlan plan;
  const ItineraryScreen({super.key, required this.plan});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> 
{
  late final ItineraryController controller;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() 
  {
    super.initState();
    controller = Get.find<ItineraryController>(tag: widget.plan.id);

    controller.setTravelersFromPlan(widget.plan);

    controller.loadItinerary(widget.plan.id!).then((_) 
    {
      if (controller.itinerary.isEmpty &&
          widget.plan.startDate != null &&
          widget.plan.endDate != null) 
      {
        controller.setDurationFromDates(widget.plan.startDate!, widget.plan.endDate!);
      }
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final isOwner = (widget.plan.people != null && widget.plan.people!.isNotEmpty)
        ? widget.plan.people!.first == currentUserId
        : false;
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
            DestinationsTab(controller: controller, isOwner: isOwner),
            ActivitiesTab(controller: controller, isOwner: isOwner),
            ExpensesTab(controller: controller, isOwner: isOwner),
          ],
        ),
      ),
    );
  }
}