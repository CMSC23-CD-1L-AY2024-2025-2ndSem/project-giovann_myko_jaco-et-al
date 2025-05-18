import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _budgetDialogShown = false;

  @override
  void initState() 
  {
    super.initState();
    // Only create a new controller if it doesn't exist for this plan
    if (Get.isRegistered<ItineraryController>(tag: widget.plan.id)) 
    {
      controller = Get.find<ItineraryController>(tag: widget.plan.id);
    } 
    
    else 
    {
      controller = Get.put(ItineraryController(), tag: widget.plan.id);
      if (widget.plan.startDate != null && widget.plan.endDate != null) 
      {
        controller.setDurationFromDates(widget.plan.startDate!, widget.plan.endDate!);
      }
      controller.setTravelersFromPlan(widget.plan);
      // controller.budget.value = widget.plan.budget ?? 0.0;
    }
    _budgetDialogShown = false;
  }

  void _showBudgetDialog(BuildContext context) 
  {
    final TextEditingController budgetController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Estimated Budget', style: TextStyle(fontWeight: FontWeight.bold,),),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            labelText: 'Enter your budget',
            prefixText: 'PHP ',
          ),
        ),
        actions: 
        [
          TextButton(
            onPressed: () 
            {
              final value = double.tryParse(budgetController.text);
              if (value != null && value > 0) 
              {
                controller.budget.value = value;
                Navigator.of(context).pop();
              } 
              
              else 
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid number.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(
              'Save',
              style: TextStyle(color: AppColors.mutedWhite),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Obx(() 
    {
      if (controller.budget.value == 0.0 && !_budgetDialogShown) 
      {
        _budgetDialogShown = true;
        Future.delayed(Duration.zero, () => _showBudgetDialog(context));
      }
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
            children: 
            [
              DestinationsTab(controller: controller),
              ActivitiesTab(controller: controller),
              ExpensesTab(controller: controller),
            ],
          ),
        ),
      );
    });
  }
}