import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/models/travel_model.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';

class CreateTravelPlanController extends GetxController{
  static CreateTravelPlanController get instance => Get.find();

  final plan = TravelPlan.empty().obs;
  final tripName = TextEditingController();
  final location = "".obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  RxString errorMessage = "".obs;

  bool validateInputs() {
  if (tripName.text.trim().isEmpty || location.isEmpty || selectedDateRange.value == null) {
    errorMessage.value = "Please fill in all fields and select a date range.";
    return false;
  }
  errorMessage.value = '';
  return true;
}

  Future<void> createPlan() async 
  { 
      final randomIndex = Random().nextInt(AppImages.illustrations.length);

      final days = selectedDateRange.value!.end.difference(selectedDateRange.value!.start).inDays + 1;

      final itinerary = List.generate(
        days,
        (i) => Itinerary(day: i + 1, expenses: [], destinations: [], activities: []),
      );
      
      var newPlan = TravelPlan(
        creator: AuthenticationController.instance.authUser!.uid,
        tripTitle: tripName.text.trim(),
        destination: location.value,
        startDate: selectedDateRange.value!.start,
        endDate: selectedDateRange.value!.end,
        imageIndex: randomIndex,
        itinerary: itinerary,
      );
      
      print(newPlan);
      newPlan = await TravelPlanDatabase.instance.addTravelPlan(newPlan);
      plan.value = newPlan;
  }
}