import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/models/user_model.dart';

class UserDatabase extends GetxController {
  static UserDatabase get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Function for saving user data
  Future <void> saveUserRecord(UserModel user) async{
    try{
      await _db.collection("Users").doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e){
      throw "Error: ${e}";
    }
  }

  //Function for retriever user email given username
  Future<String?> getEmailFromUsername(String username) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where("Username", isEqualTo: username)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()["Email"];
      }
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
    return null;
  }

  //Function for checking if username is already taken
  Future<bool> isUsernameTaken(String username) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where("username", isEqualTo: username)
          .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for checking if email is already taken
  Future<bool> isEmailTaken(String email) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where("Email", isEqualTo: email)
          .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //function for checking if phone number is already taken
  Future<bool> isPhoneNumberTaken(String phoneNumber) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where("PhoneNumber", isEqualTo: phoneNumber)
          .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for retrieving user data given a user ID
  Future<UserModel?> getUserData() async {
    try {
      final snapshot = await _db.collection("Users").doc(AuthenticationController.instance.authUser?.uid).get();
      if (snapshot.exists) {
        print("User found");
        return UserModel.fromSnapshot(snapshot);
      }else{
        print("User not found");
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for updating user data
  Future<void> updateUserData(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.uid).update(user.toJson());
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for deleting user data
  Future<void> deleteUserData(String uid) async {
    try {
      await _db.collection("Users").doc(uid).delete();
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }
}