import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/models/travel_plan_model.dart';

class TravelPlanDatabase extends GetxController {
  static TravelPlanDatabase get instance => Get.find();

  final plans = <TravelPlan>[].obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  /// Call this after login
  void listenToTravelPlans() {
    _subscription?.cancel(); // Cancel old listener if it exists

    final currentUser = AuthenticationController.instance.authUser;
    if (currentUser == null) {
      plans.value = [];
      return;
    }
    final userId = currentUser.uid;

    // Live updates of plans where user is creator or invited
    _subscription = _db.collection('TravelPlans').snapshots().listen((
      snapshot,
    ) {
      final userPlans =
          snapshot.docs
              .map((doc) {
                final data = doc.data();
                final plan = TravelPlan.fromJson(data);
                final isCreator = plan.creator == userId;
                final isInvited = plan.people?.contains(userId) ?? false;
                return (isCreator || isInvited) ? plan : null;
              })
              .whereType<TravelPlan>()
              .toList();

      plans.value = userPlans;
    });
  }

  Future<void> addTravelPlan(TravelPlan plan) async {
    await FirebaseFirestore.instance
        .collection('TravelPlans')
        .add(plan.toJson());
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
