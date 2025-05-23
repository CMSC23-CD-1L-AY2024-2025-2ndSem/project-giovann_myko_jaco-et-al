import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/models/travel_plan_model.dart';

class TravelPlanDatabase extends GetxController 
{
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
                final plan = TravelPlan.fromJson(
                  data,
                  id: doc.id,
                );
                final isCreator = plan.creator == userId;
                final isInvited = plan.people?.contains(userId) ?? false;
                return (isCreator || isInvited) ? plan : null;
              })
              .whereType<TravelPlan>()
              .toList();
    plans.value = userPlans;
  },
  onError: (error, stackTrace) {
    print('Error fetching travel plans: $error');
  },
  );
  }

  Future<TravelPlan> addTravelPlan(TravelPlan plan) async {
    final doc = await _db
        .collection('TravelPlans')
        .add(plan.toJson());
    return plan.copyWith(id: doc.id);
  }

  //Function for updating data on a travel plan except list items
  Future<void> updateTravelPlan(TravelPlan plan) async {
    await _db.collection('TravelPlans').doc(plan.id).update(plan.toJson());
  }

  Future<TravelPlan?> getPlanById(String id) async 
  {
    final doc = await _db.collection('TravelPlans').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return TravelPlan.fromJson(doc.data()!, id: doc.id);
    }
    return null;
  }

  Future<String?> getUserIdByUsername(String username) async 
  {
    // First, check 'Following' array
    var query = await _db
        .collection('Users')
        .where('Following', arrayContains: username)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) 
    {
      return query.docs.first.id;
    }

    // If not found, check 'Followers' array
    query = await _db
        .collection('Users')
        .where('Followers', arrayContains: username)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) 
    {
      return query.docs.first.id;
    }

    //temporary testing
    // query = await _db
    //     .collection('Users')
    //     .where('Username', isEqualTo: username)
    //     .limit(1)
    //     .get();

    // if (query.docs.isNotEmpty) 
    // {
    //   return query.docs.first.id;
    // }

    // Not found in either array
    return null;
  }

  Future<void> updateChecklist(TravelPlan plan, List<Checklist> updatedChecklist) async 
  {
    final updatedPlan = plan.copyWith(checklist: updatedChecklist);
    await TravelPlanDatabase.instance.updateTravelPlan(updatedPlan);
  }

  @override
  void onClose() 
  {
    _subscription?.cancel();
    super.onClose();
  }

  //Function for adding user on a travel plan
  Future<String> addPeople(String id, String uid) async 
  {
    final plan = await getPlanById(id); //finds document
    //check is null
    if(plan != null)
    {
      final people = plan.people ?? [];
      if(people.contains(uid))
      {
        return "Already in this Plan";
      }
      people.add(uid);
      plan.copyWith(people: people);
    }
    await updateTravelPlan(plan!);
    return "Successfully added to Plan!";
  }

  //Function for delete a travel plan given an id
  Future<String> deletePlan (String id) async 
  {
    try {
      await _db.collection("TravelPlans").doc(id).delete();
      return "Successfully deleted plan!";
    } catch (e) {
      return "Error: $e";
    }
  }

}
