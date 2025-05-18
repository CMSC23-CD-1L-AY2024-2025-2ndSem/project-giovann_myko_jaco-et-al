import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/firebase_options.dart';

  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "assets/env/.env");
  Get.put<AuthenticationController>(AuthenticationController());
  Get.put<TravelPlanDatabase>(TravelPlanDatabase());
  Get.put<UserDatabase>(UserDatabase());
  Get.put<UserController>(UserController());
  await AuthenticationController.instance.requestAndStoreLocation();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(App());
}
