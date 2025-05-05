import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planago/api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> userStream;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    userStream = authService.getUserStream();
  }

  Future<String> signIn(String email, String password) async {
    String message = await authService.signIn(email, password);
    notifyListeners();
    return message;
  }

  Future<String> signUp(String email, String password, String fname, String lname) async {
    String message = await authService.signUp(email, password, fname, lname);
    notifyListeners();
    return message;
  }

  Future<void> signOut() async {
    await authService.signOut();
    return;
  }
}