import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/homepage.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/authentication/login/login_page.dart';
import 'package:planago/screens/authentication/signup/sign_up_page1.dart';
import 'package:planago/screens/authentication/signup/sign_up_page2.dart';
import 'package:planago/screens/authentication/signup/sign_up_page3.dart';
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
      onGenerateRoute: (settings) {
        switch(settings.name){
          case "/":
          return MaterialPageRoute(builder: (context) => NavigationMenu());
          case "/login":
          return MaterialPageRoute(builder: (context) => LoginPage());
          case "/signup":
          return MaterialPageRoute(builder: (context) => SignUpPage1());
        }
      },
    );
  }
}
