import 'package:flutter/material.dart';
import 'package:get/get.dart';
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


  //Edit hardcoded values as needed
  //
  //  
  // Trip details
  // initialize values to avoid garbage values
  final duration = 5.obs;
  final travelers = 1.obs;
  final RxDouble budget = 0.0.obs;
  final currency = "PHP".obs;
  
  // Lists for each day
  final expenses = <List<Expense>>[].obs;
  final activities = <List<Activity>>[].obs;
  final destinations = <List<Destination>>[].obs;
  
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

  void setDurationFromDates(DateTime start, DateTime end) 
  {
    final int days = end.difference(start).inDays + 1;
    duration.value = days;
    expenses.value = List.generate(days, (_) => []);
    activities.value = List.generate(days, (_) => []);
    destinations.value = List.generate(days, (_) => []);
  }
  
  void setTravelersFromPlan(TravelPlan plan) 
  {
    travelers.value = plan.people != null ? plan.people!.length : 1;
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
    //temporary muna 'to
    // Dispose all controllers to remove unused space
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
  List<Expense> get currentDayExpenses => expenses[selectedDayIndex.value];
  List<Activity> get currentDayActivities => activities[selectedDayIndex.value];
  List<Destination> get currentDayDestinations => destinations[selectedDayIndex.value];
  
  // Expense methods
  void addExpense() 
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
    
    final dayExpenses = List<Expense>.from(expenses[selectedDayIndex.value]);
    dayExpenses.add(newExpense);
    
    final allExpenses = List<List<Expense>>.from(expenses);
    allExpenses[selectedDayIndex.value] = dayExpenses;
    expenses.value = allExpenses;
    
    // Clear controllers
    expenseDescriptionController.clear();
    expenseAmountController.clear();
    expenseCategoryController.clear();
  }
  
  void deleteExpense(String id) 
  {
    final dayExpenses = List<Expense>.from(expenses[selectedDayIndex.value]);
    dayExpenses.removeWhere((expense) => expense.id == id);
    
    final allExpenses = List<List<Expense>>.from(expenses);
    allExpenses[selectedDayIndex.value] = dayExpenses;
    expenses.value = allExpenses;
  }
  
  // Activity methods
  void addActivity() 
  {
    if (activityDescriptionController.text.isEmpty || activityTimeController.text.isEmpty || activityTypeController.text.isEmpty) 
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
    
    final dayActivities = List<Activity>.from(activities[selectedDayIndex.value]);
    dayActivities.add(newActivity);
    
    final allActivities = List<List<Activity>>.from(activities);
    allActivities[selectedDayIndex.value] = dayActivities;
    activities.value = allActivities;
    
    // Clear controllers for now
    activityDescriptionController.clear();
    activityTimeController.clear();
    activityTypeController.clear();
  }
  
  void deleteActivity(String id) 
  {
    final dayActivities = List<Activity>.from(activities[selectedDayIndex.value]);
    dayActivities.removeWhere((activity) => activity.id == id);
    
    final allActivities = List<List<Activity>>.from(activities);
    allActivities[selectedDayIndex.value] = dayActivities;
    activities.value = allActivities;
  }
  
  // Destination methods
  void addDestination() 
  {
    if (destinationNameController.text.isEmpty || destinationDescriptionController.text.isEmpty || destinationTimeController.text.isEmpty || destinationTypeController.text.isEmpty) 
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
    
    final dayDestinations = List<Destination>.from(destinations[selectedDayIndex.value]);
    dayDestinations.add(newDestination);
    
    final allDestinations = List<List<Destination>>.from(destinations);
    allDestinations[selectedDayIndex.value] = dayDestinations;
    destinations.value = allDestinations;
    
    // Clear controllers for now
    destinationNameController.clear();
    destinationDescriptionController.clear();
    destinationTimeController.clear();
    destinationTypeController.clear();
  }
  
  void deleteDestination(String id) 
  {
    final dayDestinations = List<Destination>.from(destinations[selectedDayIndex.value]);
    dayDestinations.removeWhere((destination) => destination.id == id);
    
    final allDestinations = List<List<Destination>>.from(destinations);
    allDestinations[selectedDayIndex.value] = dayDestinations;
    destinations.value = allDestinations;
  }
}