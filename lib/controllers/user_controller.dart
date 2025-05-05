import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:planago/models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Function for saving user data
  Future <void> saveUserRecord(UserModel user) {
    try{
      await _db.collection("Users").doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e){
      throw "Error: ${e}"
    }
  }
}