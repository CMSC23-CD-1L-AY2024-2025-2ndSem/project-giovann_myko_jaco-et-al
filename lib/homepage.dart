import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/provider/auth_provider.dart';
import 'package:planago/screens/authentication/login/login_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;

    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error encountered! ${snapshot.error}")),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (!snapshot.hasData) {
          return const LoginPage();
        }
        return NavigationMenu();
      },
    );
  }
}