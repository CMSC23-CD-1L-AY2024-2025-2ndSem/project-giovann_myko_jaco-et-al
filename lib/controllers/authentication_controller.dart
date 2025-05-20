
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/authentication/login/login_page.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/exceptions.dart';
import 'package:planago/utils/helper/validator.dart';
import 'package:planago/utils/loader/app_loader.dart';

class AuthenticationController extends GetxController{
  static AuthenticationController get instance => Get.find();
  Rx<Position?> userLocation = Rx<Position?>(null);

  //variables
  final errorMessage = ''.obs;
  final _auth = FirebaseAuth.instance;
  
  //User Getter
  User? get authUser => _auth.currentUser;
  // final Rxn<User> _user = Rxn<User>();

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw "Error: ${e}";
    }
  }

  Future<UserCredential?> signIn(String userCredentials, String password) async {
  try {
    print("User credentials: $userCredentials");
    String email;
    if (AppValidator.validateEmail(userCredentials) == null) {
      // Checks if the user entered an email
      email = userCredentials;
    } else {
      print("User credentials is not an email");
      // It's not a valid email, treat as username
      final matchedEmail = await UserDatabase.instance.getEmailFromUsername(userCredentials);
      print("Matched email: $matchedEmail");
      if (matchedEmail == null) {
        errorMessage.value = "Username not found";
        return null;
      }
      email = matchedEmail;
    }
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

  } on FirebaseAuthException catch (e) {
    print("Error: ${AppAuthExceptions(e.code).message}");
    errorMessage.value = AppAuthExceptions(e.code).message;
    return null;
  }
}

//Google Signin [https://www.youtube.com/watch?v=oUYiCbOETls&t=1s]
Future<void> signInWithGoogle() async {
  try {
    AppLoader.openLoadingDialog("Logging In with Google", AppImages.docerAnimation);

    final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
    if (userAccount == null) {
      AppLoader.stopLoading();
      return; // User cancelled
    }

    final GoogleSignInAuthentication googleAuth = await userAccount.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credentials);
    final email = userCredential.user?.email;
    final uid = userCredential.user?.uid;

    AppLoader.stopLoading();

    if (email == null) {
      Get.snackbar("Error", "Failed to retrieve email from Google account.");
      return;
    }

    final exists = await UserDatabase.instance.isEmailTaken(email);

    if (exists) {
      await UserController.instance.fetchUserData(); // Get user from Firestore
      TravelPlanDatabase.instance.listenToTravelPlans();
      await screenRedirect(); // Navigate to home
    } else {
      // User does not exist in Firestore
      // Navigate to sign-up screen with prefilled email (optional)
      Get.offAllNamed('/signup', arguments: {
        "uid": uid,
        "email": email,
        "fullName": userAccount.displayName ?? "",
        "profilePic": userAccount.photoUrl ?? "",
      });
    }
  } catch (e) {
    AppLoader.stopLoading();
    Get.snackbar("Google Sign-In Failed", "Something went wrong. Try again.");
    print("Google Sign-In Error: $e");
  }
}

  //SignOut
  Future<void> signOut() async {
    try{
      
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw "Error: ${e}";
    }
  }

  Future<void> screenRedirect() async {
    final user = _auth.currentUser;
    print("User: $user");
    if (user != null) {
      // User is signed in, redirect to home screen
      Get.offAll(() => NavigationMenu());
    } else {
      // User is not signed in, redirect to login screen
      // Implement checking of logged user credentials in local storage here,
      Get.offAll(() => LoginPage());
    }
  }

  Future<void> requestAndStoreLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Handle denied permission gracefully
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();
    userLocation.value = position;
    print("User location stored: ${position.latitude}, ${position.longitude}");
  }

}