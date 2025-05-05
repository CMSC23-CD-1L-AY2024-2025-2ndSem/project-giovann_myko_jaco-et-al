import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  
  //Variables
  final username = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();
  final phoneNumber = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final RxList<String> interests = <String>[].obs;
  final RxList<String> travelStyles = <String>[].obs;

  //Utility Variables
  final isPassObscured = true.obs;
  final isRePassObscured = true.obs;
  final privacyPolicy = false.obs;
  final isValid = false.obs;


  @override
  void onInit() {
    super.onInit();
    username.addListener(checkFormFilled);
    password.addListener(checkFormFilled);
    repassword.addListener(checkFormFilled);
    phoneNumber.addListener(checkFormFilled);
    ever(privacyPolicy, (_) => checkFormFilled());
  }

 void checkFormFilled() {
    isValid.value =
        username.text.isNotEmpty &&
        password.text.isNotEmpty &&
        repassword.text.isNotEmpty &&
        phoneNumber.text.isNotEmpty &&
        privacyPolicy.value;
  }


  Future<void> signUp() async {
    try{
      //Register User in Firebase Authentication
      final userCredential = await AuthenticationController.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Save Authenticated user date in Firebase Firestore
      final newUser = UserModel(uid: userCredential.user!.uid, username: username.text.trim(), 
      email: email.text.trim(), interests: interests, travelStyle: travelStyles, firstName: firstName.text.trim(), lastName: lastName.text.trim(), phoneNumber: phoneNumber.text.trim());
      final userController = Get.put(UserController());
      userController.saveUserRecord(newUser);
    }catch (e){
      throw "Error: ${e}";
    }
  }
}