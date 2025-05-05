import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/signup_controller.dart';
import 'package:planago/firebase_options.dart';

  void main() {
  Get.put<SignupController>(SignupController());
  Get.put<AuthenticationController>(AuthenticationController());
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const App());
}
