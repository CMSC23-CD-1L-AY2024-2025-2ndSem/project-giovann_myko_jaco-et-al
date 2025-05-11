import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/firebase_options.dart';
import 'package:provider/provider.dart';

  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<UserDatabase>(UserDatabase());
  Get.put<AuthenticationController>(AuthenticationController());
  Get.put<UserController>(UserController());
  runApp(App());
}
