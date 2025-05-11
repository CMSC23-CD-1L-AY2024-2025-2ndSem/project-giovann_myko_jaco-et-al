import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/loader/app_loader.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  //Variables
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final isPassObscured = true.obs;
  final isValid = false.obs;
  final rememberme = false.obs;
  final showErrorMessage = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    username.addListener(checkFormFilled);
    password.addListener(checkFormFilled);
  }

  void checkFormFilled() {
    isValid.value = formKey.currentState!.validate();
  }

  void login() async {
    try {
      //log out first for checking
      await AuthenticationController.instance.signOut();  
      print("Sucessfully logged out");    //Start loading animation
      AppLoader.openLoadingDialog("Logging you in", AppImages.docerAnimation);
      print("made it here");

      //Log in user with Firebase Authentication
      print(
        "Logging in with username: ${username.text.trim()} and password: ${password.text.trim()}",
      );
      final userCredential = await AuthenticationController.instance.signIn(
        username.text.trim(),
        password.text.trim(),
      );
      print(userCredential);
      if (userCredential == null) {
        await AppLoader.stopLoading();
        showErrorMessage.value = true;
        errorMessage.value =
            AuthenticationController.instance.errorMessage.value;
      }else{
        await UserController.instance.fetchUserData();
        await AppLoader.stopLoading();
        await AuthenticationController.instance.screenRedirect();
        print("User logged in successfully");
      }
    } catch (e) {
      AppLoader.stopLoading();
      print("Error occurred during login: $e");
      showErrorMessage.value = true;
      errorMessage.value =
          "An error occurred while logging in. Please try again.";
    }
  }

}
