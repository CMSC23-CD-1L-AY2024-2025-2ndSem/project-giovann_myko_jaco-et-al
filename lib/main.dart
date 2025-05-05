import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/signup_controller.dart';

  void main() {
  Get.put<SignupController>(SignupController());
  runApp(const App());
}
