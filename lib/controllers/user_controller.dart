import 'dart:async';

import 'package:get/get.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/utils/helper/debounce.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepo = UserDatabase.instance;
  Rx<UserModel> user = UserModel.empty().obs;

  Future<void> fetchUserData() async {
    try {
      final fetchedUser = await userRepo.getUserData();
      user(fetchedUser);
    } catch (e) {
      print("Error fetching user data: $e");
      print("Error fetching user data: $e");
      user(UserModel.empty());
    }
  }

  final RxList<UserModel> similarUsers = <UserModel>[].obs;

  Future<void> fetchSimilarUsers() async {
    try {
      final fetchedSimilarUsers = await userRepo.getMatchingUsers();
      similarUsers.assignAll(fetchedSimilarUsers);
      print("Fetched ${similarUsers.length} similar users.");
    } catch (e) {
      print("Error fetching similar users: $e");
      similarUsers.clear();
    }
  }

  Future<void> followUser(UserModel otherUser) async {
    try {
      await userRepo.followUser(otherUser);
      // para mag refresh
      await fetchUserData();
      await fetchSimilarUsers();
      //
    } catch (e) {
      print("Follow failed: $e");
    }
  }

  Future<void> unfollowUser(UserModel otherUser) async {
    try {
      await userRepo.unfollowUser(otherUser);
      // para mag refresh
      await fetchUserData();
      await fetchSimilarUsers();
      //
    } catch (e) {
      print("Unfollow failed: $e");
    }
  }

  final RxList<UserModel> searchResults = <UserModel>[].obs;
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  @override
  void onClose() {
    _debouncer.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    _debouncer.run(() async {
      if (query.isEmpty) {
        searchResults.clear();
      } else {
        final searchedUsers = await userRepo.getUsersByQuery(query);
        searchResults.assignAll(searchedUsers);
        print("Users found!");
      }
    });
  }

  Future<void> editUserProfile(UserModel user) async {
    try {
      await userRepo.updateUserData(user);
      // refresh details on app
      fetchUserData();
      print("Update successful!");
    } catch (e) {
      print("Update failed: $e");
    }
  }

  Future<UserModel> fetchCreator(String creatorId) async {
    return await userRepo.getPlanCreator(creatorId);
  }
}
