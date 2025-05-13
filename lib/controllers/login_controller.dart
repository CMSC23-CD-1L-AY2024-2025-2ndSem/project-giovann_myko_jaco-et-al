import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
{
  static LoginController get instance => Get.find();

  //Variables
  final username = TextEditingController();
  final password = TextEditingController();
  final isPassObscured = true.obs;
  final isValid = false.obs;

  @override
  void onInit() 
  {
    super.onInit();
    username.addListener(checkFormFilled);
    password.addListener(checkFormFilled);
  }

  void checkFormFilled() 
  {
    isValid.value =
        username.text.isNotEmpty && password.text.isNotEmpty;
  }

}