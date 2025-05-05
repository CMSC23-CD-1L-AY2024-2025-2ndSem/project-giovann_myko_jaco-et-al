
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController{
  static AuthenticationController get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;

  Stream<User?> getUserStream(){
    return _auth.authStateChanges();
  }

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw "Error: ${e}";
    }
  }

}