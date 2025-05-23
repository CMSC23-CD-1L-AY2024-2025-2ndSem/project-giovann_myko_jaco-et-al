import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/firestore/itinerary_database.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:uuid/uuid.dart';
import '/models/travel_model.dart';

class ItineraryController extends GetxController 
{
  final selectedTabIndex = 0.obs;
  final selectedDayIndex = 0.obs;
  final uuid = Uuid();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  final duration = 5.obs;
  final travelers = 1.obs;
  final currency = "PHP".obs;

  final itinerary = <Itinerary>[].obs;

  // Text controllers for expenses
  final expenseDescriptionController = TextEditingController();
  final expenseAmountController = TextEditingController();
  final expenseCategoryController = TextEditingController();

  // Text controllers for activities
  final activityDescriptionController = TextEditingController();
  final activityTimeController = TextEditingController();
  final activityTypeController = TextEditingController();

  // Text controllers for destinations
  final destinationNameController = TextEditingController();
  final destinationDescriptionController = TextEditingController();
  final destinationTimeController = TextEditingController();
  final destinationTypeController = TextEditingController();

  String? travelPlanId ;

  Future<void> loadItinerary(String planId) async 
  {
    travelPlanId = planId;
    final loaded = await ItineraryDatabase.instance.getItinerary(planId);
    if (loaded.isNotEmpty) 
    {
      duration.value = loaded.length;
      itinerary.value = loaded;
    }
  }

  Future<void> saveItinerary() async 
  {
    if (travelPlanId == null) 
    {
      // print('travelPlanId is null!');
      return;
    }
    // print('Saving itinerary: ${itinerary.map((e) => e.toJson()).toList()}');
    await ItineraryDatabase.instance.setItinerary(travelPlanId!, itinerary);
  }
  void setDurationFromDates(DateTime start, DateTime end) 
  {
    final int days = end.difference(start).inDays + 1;
    duration.value = days;
    itinerary.value = List.generate(
      days,
      (i) => Itinerary(day: i + 1, expenses: [], destinations: [], activities: []),
    );
    saveItinerary();
  }

  void setTravelersFromPlan(TravelPlan plan) 
  {
    // print("Setting travelers from plan: ${plan.people}");
    if (plan.people == null || plan.people!.isEmpty) 
    {
      travelers.value = 1;
    } 
    
    else 
    {
      travelers.value = plan.people!.length + 1;
    }
  }

  double get currentDayTotalExpenses 
  {
    double sum = 0.0;
    for (var expense in currentDayExpenses) 
    {
      sum += expense.amount;
    }
    return sum;
  }

  @override
  void onClose() 
  {
    expenseDescriptionController.dispose();
    expenseAmountController.dispose();
    expenseCategoryController.dispose();

    activityDescriptionController.dispose();
    activityTimeController.dispose();
    activityTypeController.dispose();

    destinationNameController.dispose();
    destinationDescriptionController.dispose();
    destinationTimeController.dispose();
    destinationTypeController.dispose();

    super.onClose();
  }

  void changeTab(int index) 
  {
    selectedTabIndex.value = index;
  }

  void selectDay(int index) 
  {
    if (index >= 0 && index < duration.value) 
    {
      selectedDayIndex.value = index;
    }
  }

  // Getters for current day items
  List<Expense> get currentDayExpenses => itinerary.isNotEmpty ? itinerary[selectedDayIndex.value].expenses : [];
  List<Activity> get currentDayActivities => itinerary.isNotEmpty ? itinerary[selectedDayIndex.value].activities : [];
  List<Destination> get currentDayDestinations => itinerary.isNotEmpty ? itinerary[selectedDayIndex.value].destinations : [];

  // Expense methods
  Future<void> addExpense() async 
  {
    if (expenseDescriptionController.text.isEmpty ||
        expenseAmountController.text.isEmpty ||
        expenseCategoryController.text.isEmpty) 
    {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final amount = double.tryParse(expenseAmountController.text) ?? 0.0;

    final newExpense = Expense(
      id: uuid.v4(),
      description: expenseDescriptionController.text,
      amount: amount,
      category: expenseCategoryController.text,
      date: DateTime.now(),
    );

    final day = selectedDayIndex.value;
    final updatedDay = itinerary[day].copyWith(
      expenses: [...itinerary[day].expenses, newExpense],
    );
    itinerary[day] = updatedDay;

    expenseDescriptionController.clear();
    expenseAmountController.clear();
    expenseCategoryController.clear();

    await saveItinerary();
  }

  Future<void> deleteExpense(String id) async 
  {
    final day = selectedDayIndex.value;
    final updatedExpenses = itinerary[day].expenses.where((e) => e.id != id).toList();
    itinerary[day] = itinerary[day].copyWith(expenses: updatedExpenses);
    await saveItinerary();
  }

  // Activity methods
  Future<void> addActivity() async 
  {
    if (activityDescriptionController.text.isEmpty ||
        activityTimeController.text.isEmpty ||
        activityTypeController.text.isEmpty) 
    {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newActivity = Activity(
      id: uuid.v4(),
      description: activityDescriptionController.text,
      time: activityTimeController.text,
      type: activityTypeController.text,
      date: DateTime.now(),
    );

    final day = selectedDayIndex.value;
    final updatedDay = itinerary[day].copyWith(
      activities: [...itinerary[day].activities, newActivity],
    );
    itinerary[day] = updatedDay;

    activityDescriptionController.clear();
    activityTimeController.clear();
    activityTypeController.clear();

    await saveItinerary();
  }

  Future<void> updateActivity(String id, Activity updatedActivity) async 
  {
    final day = selectedDayIndex.value;
    final activities = itinerary[day].activities.map((a) => a.id == id ? updatedActivity : a).toList();
    itinerary[day] = itinerary[day].copyWith(activities: activities);
    await saveItinerary();
  }

  Future<void> deleteActivity(String id) async 
  {
    final day = selectedDayIndex.value;
    final updatedActivities = itinerary[day].activities.where((a) => a.id != id).toList();
    itinerary[day] = itinerary[day].copyWith(activities: updatedActivities);
    await saveItinerary();
  }

  // Destination methods
  Future<void> addDestination() async 
  {
    if (destinationNameController.text.isEmpty ||
        destinationDescriptionController.text.isEmpty ||
        destinationTimeController.text.isEmpty ||
        destinationTypeController.text.isEmpty) 
    {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newDestination = Destination(
      id: uuid.v4(),
      name: destinationNameController.text,
      description: destinationDescriptionController.text,
      time: destinationTimeController.text,
      type: destinationTypeController.text,
    );

    final day = selectedDayIndex.value;
    final updatedDay = itinerary[day].copyWith(
      destinations: [...itinerary[day].destinations, newDestination],
    );
    itinerary[day] = updatedDay;

    destinationNameController.clear();
    destinationDescriptionController.clear();
    destinationTimeController.clear();
    destinationTypeController.clear();

    await saveItinerary();
  }

  Future<void> deleteDestination(String id) async 
  {
    final day = selectedDayIndex.value;
    final updatedDestinations = itinerary[day].destinations.where((d) => d.id != id).toList();
    itinerary[day] = itinerary[day].copyWith(destinations: updatedDestinations);
    await saveItinerary();
  }
}