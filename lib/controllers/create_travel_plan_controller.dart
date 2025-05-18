import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/models/travel_plan_model.dart';
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

  Future<void> createPlan() async { 
      // final randomIndex = Random().nextInt(items.length);
      // var image = AppConvert.convertAssetToBase64(AssetImage.places[])
      var newPlan = TravelPlan(creator: AuthenticationController.instance.authUser!.uid, tripTitle: tripName.text.trim(), destination: location.value, startDate: selectedDateRange.value!.start, endDate: selectedDateRange.value!.end);
      newPlan = await TravelPlanDatabase.instance.addTravelPlan(newPlan);
      plan.value = newPlan;
  }
}