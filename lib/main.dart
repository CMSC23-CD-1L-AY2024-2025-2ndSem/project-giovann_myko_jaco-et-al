import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/app.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/login_controller.dart';
import 'package:planago/controllers/signup_controller.dart';
import 'package:planago/firebase_options.dart';
import 'package:planago/provider/auth_provider.dart';
import 'package:provider/provider.dart';

  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put<SignupController>(SignupController());
  Get.put<AuthenticationController>(AuthenticationController());
  Get.put<LoginController>(LoginController());
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthProvider()),
      ],
      child: App(),
    ),
  );
}
