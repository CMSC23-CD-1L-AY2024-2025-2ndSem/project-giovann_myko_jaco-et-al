import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/authentication/login/login_page.dart';
import 'package:planago/screens/authentication/signup/sign_up_page1.dart';
import 'package:planago/utils/theme/theme.dart';

class App extends StatelessWidget 
{
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme,
      initialRoute: "/login",
      getPages: [
    GetPage(name: "/", page: () => NavigationMenu()),
    GetPage(name: "/login", page: () => LoginPage()),
    GetPage(name: "/signup", page: () => SignUpPage1()),
  ],
    );
  }
}
