import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/models/user_model.dart';

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
    _subscription = _db
        .collection('TravelPlans')
        .snapshots()
        .listen(
          (snapshot) {
            final userPlans =
                snapshot.docs
                    .map((doc) {
                      final data = doc.data();
                      final plan = TravelPlan.fromJson(data, id: doc.id);
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
    final doc = await _db.collection('TravelPlans').add(plan.toJson());
    return plan.copyWith(id: doc.id);
  }

  //Function for updating data on a travel plan except list items
  Future<void> updateTravelPlan(TravelPlan plan) async {
    await _db.collection('TravelPlans').doc(plan.id).update(plan.toJson());
  }

  Future<TravelPlan?> getPlanById(String id) async {
    final doc = await _db.collection('TravelPlans').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return TravelPlan.fromJson(doc.data()!, id: doc.id);
    }
    return null;
  }
  
  Future<String?> getUserIdByUsername(String username) async 
  {
    var query = await _db
    .collection('Users')
    .where('Following', arrayContains: username)
    .get();

    if (query.docs.isNotEmpty) 
    {
      var userQuery = await _db
          .collection('Users')
          .where('Username', isEqualTo: username)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) 
      {
        return userQuery.docs.first.id;
      }
    }

    // // If not found, check 'Followers' array
    // query = await _db
    //     .collection('Users')
    //     .where('Followers', arrayContains: username)
    //     .limit(1)
    //     .get();

    // if (query.docs.isNotEmpty) 
    // {
    //   return query.docs.first.id;
    // }

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
  Future<String> addPeople(String id, String uid) async {
    final plan = await getPlanById(id); //finds document
    //check is null
    if (plan != null) {
      final people = plan.people ?? [];
      if (people.contains(uid)) {
        return "Already in this Plan";
      }
      people.add(uid);
      final updatedPlan = plan.copyWith(people: people);
      await updateTravelPlan(updatedPlan);
      return "Successfully added to Plan!";
    }
    return "Plan not found";
  }

  //Function for delete a travel plan given an id
  Future<String> deletePlan(String id) async {
    try {
      await _db.collection("TravelPlans").doc(id).delete();
      return "Successfully deleted plan!";
    } catch (e) {
      return "Error: $e";
    }
  }

  final RxList<UserModel> tripmateSuggestion = <UserModel>[].obs;

  Future<void> getTripSuggestions(TravelPlan plan) async {
    try {
      final currentUserId = AuthenticationController.instance.authUser?.uid;
      if (currentUserId == null) {
        tripmateSuggestion.clear();
        return;
      }

      final userDoc = await _db.collection("Users").doc(currentUserId).get();
      final userData = userDoc.data();
      if (userData == null) {
        tripmateSuggestion.clear();
        return;
      }

      final followers = List<String>.from(userData["Followers"] ?? []);
      print(followers);
      final planPeopleIds = plan.people ?? [];

      final Set<String> userIds = {...followers, ...planPeopleIds};
      userIds.remove(currentUserId);

      final List<UserModel> users = [];
      for (final uid in userIds) {
        final userSnap = await _db.collection("Users").doc(uid).get();
        if (userSnap.exists) {
          users.add(UserModel.fromSnapshot(userSnap));
        }
      }

      users.sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
      );

      tripmateSuggestion.assignAll(users);
    } on FirebaseException catch (e) {
      throw Exception("Firebase error [${e.code}]: ${e.message}");
    }
  }

  Future<void> addPersonToPlan(String planId, String uid) async {
    try {
      final planRef = _db.collection("TravelPlans").doc(planId);

      await planRef.update({
        "people": FieldValue.arrayUnion([uid]),
      });
    } on FirebaseException catch (e) {
      throw Exception("Error adding person to plan: ${e.message}");
    }
  }

  Future<void> removePersonFromPlan(String planId, String uid) async {
    try {
      final planRef = _db.collection("TravelPlans").doc(planId);

      await planRef.update({
        "people": FieldValue.arrayRemove([uid]),
      });
    } on FirebaseException catch (e) {
      throw Exception("Error removing person from plan: ${e.message}");
    }
  }
}
