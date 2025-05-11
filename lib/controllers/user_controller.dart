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
      print("User fetched: ${user.value.username}");
    } catch (e) {
      print("Error fetching user data: $e");
      print("Error fetching user data: $e");
      user(UserModel.empty());
    }
  }
}