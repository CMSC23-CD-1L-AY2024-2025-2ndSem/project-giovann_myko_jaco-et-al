import 'package:get/get.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/models/user_model.dart';

class UserController extends GetxController{ 
  static UserController get instance => Get.find();

  final userRepo = UserDatabase.instance;
  Rx<UserModel> user =  UserModel.empty().obs;
  
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
      final fetchedSimilarUsers = await userRepo.findSimilarUsers(user.value);
      similarUsers.assignAll(fetchedSimilarUsers);
      print("Fetched ${similarUsers.length} similar users.");
    } catch (e) {
      print("Error fetching similar users: $e");
      similarUsers.clear();
    }
  }

  Future<void> followUser(UserModel otherUser) async {
    try {
      await userRepo.followUser(otherUser.username);
      await fetchUserData(); // para mag refresh
    } catch (e) {
      print("Follow failed: $e");
    }
  }

  Future<void> unfollowUser(UserModel otherUser) async {
    try {
      await userRepo.unfollowUser(otherUser.username);
      await fetchUserData(); // para mag refresh
    } catch (e) {
      print("Unfollow failed: $e");
    }
  }

}