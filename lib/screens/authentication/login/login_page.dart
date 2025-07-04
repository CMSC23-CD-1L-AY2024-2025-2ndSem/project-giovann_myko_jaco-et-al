import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/controllers/login_controller.dart';
import 'package:planago/screens/authentication/signup/sign_up_page1.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/helper/validator.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.put(LoginController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* 
      responsive UI - for phones only
      -------------------------------
      - percentages calculated using standard phone size
      multiplied with wireframe dimensions and/or utils/constant

      Common fontSize 
      {
        fonts relative to height
        13 => 1.5%
        12 => 1.38%
        16 => 1.83%
        20 => 2.3%
        35 => 4.01%
      }

      Icons: 18 => 2% 

      Main Container 
      {
        left and right padding: 6% each
        remaining phone width: 88%
        spacing: AppSizes.spaceBtwItems => 1.83%
      }

      loginText 
      {
        width: 88%
        height: 22%
      }

      usernameField & passwordField
      {
        width: 88%
        height: 6.5%
        cursorHeight: 18 => 2%
      }

      loginOptions 
      {
        width: 88%
        height: 3.9%
        cursorHeight: 18 => 2%
      }

      signIn 
      {
        width: 88%
        height: 5.27%
      }

      divider 
      {
        width: 88%
        height: 1.8%
        Divider indent: 3.06%
        Divider endIndent: 2.04%
      }

      googleSignIn 
      {
        width: 88%
        height: 9.15%
        OutlinedButton height: 5.27%
        Sign up TextButton: 3.7%
      }

      brand 
      {
        width: 88%
        height: 32.07% - remaining phone height
      }
      -------------------------------

    
    */
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.mutedWhite,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: screenWidth * 0.06,
              right: screenWidth * 0.06,
            ),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              onChanged: controller.checkFormFilled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: screenHeight * 0.0183,
                children: [
                  loginText(screenWidth, screenHeight),
                  //Username Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 1,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        validator:
                            (value) => AppValidator.validateEmptyText(
                              "Username",
                              value,
                            ),
                        controller: controller.username,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          filled: true,
                          fillColor: Color.fromARGB(255, 245, 247, 251),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          prefixIcon: Icon(
                            Iconsax.user,
                            size: screenHeight * 0.02,
                            color: Color.fromARGB(255, 155, 155, 156),
                          ),
                          labelText: "Enter your username",
                          labelStyle: TextStyle(
                            letterSpacing: -0.3,
                            fontSize: screenHeight * 0.015,
                            color: Color.fromARGB(255, 155, 155, 156),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          errorStyle: TextStyle(
                            color: AppColors.secondary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        style: TextStyle(fontSize: screenHeight * 0.015),
                        cursorHeight: screenHeight * 0.02,
                        cursorColor: Color.fromARGB(255, 155, 155, 156),
                      ),
                    ],
                  ),

                  //Password Field
                  Column(
                    spacing: 1,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        controller: controller.password,
                        validator:
                            (value) => AppValidator.validatePassword(value),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          filled: true,
                          fillColor: Color.fromARGB(255, 245, 247, 251),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          prefixIcon: Icon(
                            Iconsax.lock,
                            size: screenHeight * 0.02,
                            color: Color.fromARGB(255, 155, 155, 156),
                          ),
                          labelText: "Enter your password",
                          labelStyle: TextStyle(
                            fontSize: screenHeight * 0.015,
                            letterSpacing: -0.3,
                            color: Color.fromARGB(255, 155, 155, 156),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isPassObscured.value =
                                  !controller.isPassObscured.value;
                            },
                            icon: Icon(
                              controller.isPassObscured.value
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash,
                              size: screenHeight * 0.02,
                              color: Color.fromARGB(255, 155, 155, 156),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          errorStyle: TextStyle(
                            color: AppColors.secondary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        obscureText: controller.isPassObscured.value,
                        style: TextStyle(fontSize: screenHeight * 0.015),
                        cursorHeight: screenHeight * 0.02,
                        cursorColor: Color.fromARGB(255, 155, 155, 156),
                      ),
                    ],
                  ),
                  loginOptions(screenWidth, screenHeight),
                  signIn(screenWidth, screenHeight),
                  controller.showErrorMessage.value
                      ? signInErrorMessage(controller.errorMessage.value)
                      : Container(),
                  divider(screenWidth, screenHeight),
                  googleSignIn(screenWidth, screenHeight),
                  brand(screenWidth, screenHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginText(double width, double height) => Container(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 87),
    width: width * 0.88,
    height: height * 0.22,
    child: Center(
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          letterSpacing: -0.5,
        ),
      ),
    ),
  );

  Widget signInErrorMessage(String text) => Padding(
    padding: EdgeInsets.only(bottom: 30),
    child: Text(text, style: TextStyle(color: Colors.red)),
  );

  Widget loginOptions(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.039, // adjusted, hindi nakikita text button kapag 18px
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: controller.rememberme.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(
                color: Color.fromARGB(255, 155, 155, 156),
                width: 1.5,
              ),
              activeColor: AppColors.primary,
              onChanged:
                  (value) =>
                      controller.rememberme.value =
                          !controller.rememberme.value,
            ),
            Text(
              "Remember me",
              style: TextStyle(
                letterSpacing: -0.2,
                fontSize: height * 0.0138,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Forgot password?",
            style: TextStyle(
              letterSpacing: -0.3,
              fontSize: height * 0.0138,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    ),
  );

  Widget signIn(double width, double height) => Container(
    width: width * 0.88,
    height: height * 0.0527,
    decoration: BoxDecoration(
      gradient:
          controller.isValid.value
              ? LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
              : LinearGradient(
                colors: [
                  Color.fromARGB(255, 160, 160, 160),
                  Color.fromARGB(255, 160, 160, 160),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      borderRadius: BorderRadius.circular(100),
    ),
    child: OutlinedButton(
      onPressed: () async {
        if (controller.formKey.currentState!.validate()) {
          controller.formKey.currentState!.save();
          controller.login();
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.transparent),
      ),
      child: Text(
        "Sign in",
        style: TextStyle(
          letterSpacing: -0.5,
          color: AppColors.mutedWhite,
          fontSize: height * 0.023,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget divider(double width, double height) => SizedBox(
    height: height * 0.018,
    width: width * 0.88,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Divider(
            color: Color.fromARGB(255, 42, 42, 42),
            indent: width * 0.0306,
            endIndent: width * 0.0204,
          ),
        ),
        Text(
          "or",
          style: TextStyle(
            letterSpacing: -0.3,
            fontSize: height * 0.015,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 42, 42, 42),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color.fromARGB(255, 42, 42, 42),
            indent: width * 0.0306,
            endIndent: width * 0.0204,
          ),
        ),
      ],
    ),
  );

  Widget googleSignIn(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.0915,
    child: Column(
      children: [
        SizedBox(
          height: height * 0.0527,
          child: OutlinedButton(
            onPressed: () async {
              await controller.googleSignIn();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color.fromARGB(255, 82, 82, 82)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/google_logo.png',
                  width: width * 0.0638,
                  height: height * 0.0298,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Continue with Google",
                      style: TextStyle(
                        letterSpacing: -0.5,
                        color: Color.fromARGB(255, 82, 82, 82),
                        fontSize: height * 0.0183,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.0638),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: "Poppins",
              color: Color.fromARGB(255, 82, 82, 82),
              fontSize: height * 0.0138,
              letterSpacing: -0.2,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: "Don't have an account? "),
              TextSpan(
                text: "Sign up",
                style: TextStyle(fontWeight: FontWeight.w600),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        Get.offAll(() => SignUpPage1());
                      },
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget brand(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.3207,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 5,
          child: GradientText(
            "PlanaGo",
            style: TextStyle(fontSize: height * 0.0401, fontFamily: 'Cal Sans'),
            colors: [AppColors.primary, AppColors.secondary],
            gradientType: GradientType.linear,
            gradientDirection: GradientDirection.ltr,
          ),
        ),
        Spacer(flex: 1),
      ],
    ),
  );
}
