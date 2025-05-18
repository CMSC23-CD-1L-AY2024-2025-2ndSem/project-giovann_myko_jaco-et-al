import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';
import 'package:planago/utils/loader/app_loader.dart';

class SignupController extends GetxController
{
  static SignupController get instance => Get.find();

  final signUp1key = GlobalKey<FormState>();
  final signUp2key = GlobalKey<FormState>();
  //Variables
  final Rx<String> avatar = "".obs;
  final username = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();
  final phoneNumber = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final RxList<String> interests = <String>[].obs;
  final RxList<String> travelStyles = <String>[].obs;
  final selectedAvatarIndex = (-1).obs;

  //Utility Variables
  final isPassObscured = true.obs;
  final isRePassObscured = true.obs;
  final privacyPolicy = false.obs;
  final isValid = false.obs;
  final isForm2Valid = false.obs;
  final usernameError = ''.obs;
  final emailError = ''.obs;
  final phoneNumberError = ''.obs;


  void checkFormFilled() {
    usernameError.value = '';
    phoneNumberError.value = '';
    if(signUp1key.currentState!.validate() && privacyPolicy.value){
      isValid.value = true;
    }else{
      isValid.value = false;
    }
  }

  void checkForm2Filled() {
    emailError.value = '';
    if(signUp2key.currentState!.validate()){
      isForm2Valid.value = true;
    }else{
      isForm2Valid.value = false;
    }
  }

  Future<void> signUp() async {
    try{
      //Start loading animation
      AppLoader.openLoadingDialog("Creating your account", AppImages.docerAnimation);
      //Register User in Firebase Authentication
      final userCredential = await AuthenticationController.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Convert avatar to base64
      final base64Avatar = await AppConvert.convertAssetToBase64(avatar.value);

      //Save Authenticated user date in Firebase Firestore
      final newUser = UserModel(uid: userCredential.user!.uid, username: username.text.trim(), avatar: base64Avatar, isPrivate: false,
      email: email.text.trim(), interests: interests, travelStyle: travelStyles, firstName: firstName.text.trim(), lastName: lastName.text.trim(), phoneNumber: phoneNumber.text.trim());
      UserController.instance.user(newUser);
      final userController = Get.put(UserDatabase());
      userController.saveUserRecord(newUser);
      await AppLoader.stopLoading();
      await AuthenticationController.instance.screenRedirect();
    }catch (e){
      throw "Error: ${e}";
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
  final existingUser = await UserDatabase.instance.getEmailFromUsername(username);
  return existingUser == null; // true if available
}

  Future<bool> isEmailAvailable(String email) async {
    final existingEmail = await UserDatabase.instance.isEmailTaken(email);
    return existingEmail == false; // true if available
  }

  Future<bool> isPhoneNumberAvailable(String phoneNumber) async {
    final existingNumber = await UserDatabase.instance.isPhoneNumberTaken(phoneNumber);
    return existingNumber == false; // true if available
  }
}