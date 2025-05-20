import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';
import 'package:planago/utils/loader/app_loader.dart';

class SignupController extends GetxController
{
  static SignupController get instance => Get.find();

  RxBool isGoogleSignUp = false.obs;

  // Optional Google user data (passed via arguments)
  String? googleUid;
  String? googleEmail;
  String? googleFullName;
  String? googleProfilePic;

  //Custom Constructor for Google auth sign up
  SignupController({String? prefilledEmail}) {
    final args = Get.arguments;
    if (args != null) {
      isGoogleSignUp.value = true;
      googleUid = args['uid'];
      googleEmail = args['email'];
      googleFullName = args['fullName'];
      googleProfilePic = args['profilePic'];

      // Prefill email field
      if (googleEmail != null) {
        email.text = googleEmail!;
      }
      // Prefill name fields from fullName if available
      if (googleFullName != null && googleFullName!.trim().isNotEmpty) {
        final nameParts = googleFullName!.trim().split(' ');
        if (nameParts.length == 1) {
          firstName.text = nameParts[0];
          lastName.text = '';
        } else {
          lastName.text = nameParts.last;
          firstName.text = nameParts.sublist(0, nameParts.length - 1).join(' ');
        }
        isForm2Valid.value = true;
      }
    } else {
      // Normal signup flow (email prefill if any)
      if (prefilledEmail != null) {
        email.text = prefilledEmail;
      }
    }
  }


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
    }
    else{
      isForm2Valid.value = false;
    }
  }

  Future<void> signUp() async {
  try {
    AppLoader.openLoadingDialog("Creating your account", AppImages.docerAnimation);

    UserModel newUser;

    if (isGoogleSignUp.value) {
      // Google signup completion: No password registration here, user already authenticated by Google.

      // Use googleUid for Firebase UID, email and profilePic from Google data

      newUser = UserModel(
        uid: googleUid!,
        username: username.text.trim(),
        avatar: googleProfilePic ?? '',
        isPrivate: false,
        email: googleEmail!,
        interests: interests,
        travelStyle: travelStyles,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        following: [],
        followers: 0,
      );

      // Save user in Firestore without Firebase Auth registration step
      UserController.instance.user(newUser);
      final userController = Get.put(UserDatabase());
      await userController.saveUserRecord(newUser);
    } else {
      // Normal signup with email/password
      final userCredential = await AuthenticationController.instance
          .registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      final base64Avatar = await AppConvert.convertAssetToBase64(avatar.value);

      newUser = UserModel(
        uid: userCredential.user!.uid,
        username: username.text.trim(),
        avatar: base64Avatar,
        isPrivate: false,
        email: email.text.trim(),
        interests: interests,
        travelStyle: travelStyles,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        following: [],
        followers: 0,
      );

      UserController.instance.user(newUser);
      final userController = Get.put(UserDatabase());
      await userController.saveUserRecord(newUser);
    }

    TravelPlanDatabase.instance.listenToTravelPlans();
    await AppLoader.stopLoading();
    await AuthenticationController.instance.screenRedirect();

  } catch (e) {
    await AppLoader.stopLoading();
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