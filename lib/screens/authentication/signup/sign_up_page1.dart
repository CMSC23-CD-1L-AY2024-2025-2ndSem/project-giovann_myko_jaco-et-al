import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/controllers/signup_controller.dart';
import 'package:planago/screens/authentication/login/login_page.dart';
import 'package:planago/screens/authentication/signup/sign_up_page2.dart';

import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/texts.dart';
import 'package:planago/utils/helper/validator.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUpPage1 extends StatelessWidget {
  SignUpPage1({super.key});

  final String? prefilledEmail = Get.arguments?['email'];
  late final SignupController controller;
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;
    controller = Get.put(SignupController(prefilledEmail: prefilledEmail));

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.mutedWhite,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Form(
              onChanged: controller.checkFormFilled,
              autovalidateMode: AutovalidateMode.onUnfocus,
              key: controller.signUp1key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: screenHeight * 0.0183,
                children: [
                  signUpHeader(screenWidth, screenHeight),
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
                          errorText: controller.usernameError.value.isEmpty ? null : controller.usernameError.value,
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
                        enabled: !controller.isGoogleSignUp.value,
                        controller: controller.password,
                        validator:
                            (value) {
                              if(controller.isGoogleSignUp.value){
                                return null;
                              }
                              AppValidator.validatePassword(value);
                            },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          filled: true,
                          fillColor: controller.isGoogleSignUp.value ? const Color.fromARGB(255, 199, 199, 199) : Color.fromARGB(255, 245, 247, 251),
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
                  //Confirm Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 1,
                    children: [
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        enabled: !controller.isGoogleSignUp.value,
                        validator: (value) {
                          if(controller.isGoogleSignUp.value){
                            return null;
                          }
                          if (value == null || value.isEmpty) {
                            return "Please re-enter your password";
                          }
                          if (value != controller.password.text) {
                            return "Password Mismatch";
                          }
                          return null;
                        },
                        controller: controller.repassword,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          filled: true,
                          fillColor: controller.isGoogleSignUp.value ? const Color.fromARGB(255, 199, 199, 199) : Color.fromARGB(255, 245, 247, 251),
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
                          labelText: "Re-enter your password",
                          labelStyle: TextStyle(
                            fontSize: screenHeight * 0.015,
                            letterSpacing: -0.3,
                            color: Color.fromARGB(255, 155, 155, 156),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isRePassObscured.value =
                                  !controller.isRePassObscured.value;
                            },
                            icon: Icon(
                              controller.isRePassObscured.value
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
                        obscureText: controller.isRePassObscured.value,
                        style: TextStyle(fontSize: screenHeight * 0.015),
                        cursorHeight: screenHeight * 0.02,
                        cursorColor: Color.fromARGB(255, 155, 155, 156),
                      ),
                    ],
                  ),
                  //Phone number field
                  Column(
                    spacing: 1,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      TextFormField(
                        controller: controller.phoneNumber,
  
                        validator:
                            (value) => AppValidator.validatePhoneNumber(value),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          errorText: controller.phoneNumberError.value.isEmpty ? null : controller.phoneNumberError.value,
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
                            CupertinoIcons.phone,
                            size: screenHeight * 0.02,
                            color: Color.fromARGB(255, 155, 155, 156),
                          ),
                          labelText: "+63 -----------",
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
                  privacyPolicy(screenWidth, screenHeight),
                  //Continue Button
                  Container(
                    width: screenWidth * 0.88,
                    height: screenHeight * 0.0527,
                    decoration: BoxDecoration(
                      gradient:
                          controller.isValid.value
                              ? LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
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
                      onPressed:
                          controller.isValid.value
                              ? () async {
                                if (!await controller.isUsernameAvailable(controller.username.text)) {
                                  controller.usernameError.value =
                                      "Username already taken";
                                }

                                if (!await controller.isPhoneNumberAvailable(controller.phoneNumber.text)) {
                                  controller.phoneNumberError.value =
                                      "Phone number already taken";
                                }

                                if(await controller.isPhoneNumberAvailable(controller.phoneNumber.text) && await controller.isUsernameAvailable(controller.username.text)){
                                  Get.to(() => SignUpPage2());
                                }
                              }
                              : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.transparent),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          letterSpacing: -0.5,
                          color: AppColors.mutedWhite,
                          fontSize: screenHeight * 0.023,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color.fromARGB(255, 82, 82, 82),
                        fontSize: screenHeight * 0.0158,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAll(() => LoginPage());
                                },
                        ),
                      ],
                    ),
                  ),
                  brand(screenWidth, screenHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpHeader(double width, double height) => Container(
    padding: EdgeInsets.only(bottom: 0),
    width: width * 0.88,
    height: height * 0.15,
    child: Center(
      child: Text(
        "Signup",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          foreground:
              Paint()
                ..shader = LinearGradient(
                  colors: <Color>[AppColors.primary, AppColors.secondary],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          letterSpacing: -0.5,
        ),
      ),
    ),
  );

  Widget privacyPolicy(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.09,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
          value: controller.privacyPolicy.value,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          side: BorderSide(
            color: Color.fromARGB(255, 155, 155, 156),
            width: 1.5,
          ),
          activeColor: AppColors.primary,
          onChanged: (value) {
            controller.privacyPolicy.value = !controller.privacyPolicy.value;
            controller.checkFormFilled();
          },
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              AppTexts.privacyPolicy,
              style: TextStyle(
                letterSpacing: -0.2,
                fontSize: height * 0.0138,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget continueButton(double width, double height) => Container(
    width: width * 0.88,
    height: height * 0.0527,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(100),
    ),
    child: OutlinedButton(
      onPressed: () {
        Get.to(() => SignUpPage2());
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.transparent),
      ),
      child: Text(
        "Continue",
        style: TextStyle(
          letterSpacing: -0.5,
          color: AppColors.mutedWhite,
          fontSize: height * 0.023,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget brand(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.2,
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
