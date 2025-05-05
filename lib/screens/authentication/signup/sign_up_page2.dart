import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/components/app_bar.dart';
import 'package:planago/components/custom_app_bar.dart';
import 'package:planago/controllers/signup_controller.dart';
import 'package:planago/screens/authentication/signup/sign_up_page3.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/helper/validator.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUpPage2 extends StatelessWidget {
  const SignUpPage2({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final controller = SignupController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarReturn(),
              //Header
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      "Create your Profile",
                      style: TextStyle(
                        fontSize: Get.height * 0.0401,
                        fontFamily: 'Cal Sans',
                      ),
                      colors: [AppColors.primary, AppColors.secondary],
                      gradientType: GradientType.linear,
                      gradientDirection: GradientDirection.ltr,
                    ),
                    Text(
                      "Let us know you!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        fontSize: Get.height * 0.016,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              //Form
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  children: [
                    //First Name Field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            "First Name",
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
                                  "First Name",
                                  value,
                                ),
                            controller: controller.firstName,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
                              label: Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "Enter your first name",
                                  style: TextStyle(
                                    letterSpacing: -0.3,
                                    fontSize: screenHeight * 0.015,
                                    color: Color.fromARGB(255, 155, 155, 156),
                                  ),
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              errorStyle: TextStyle(
                                color: AppColors.secondary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            style: TextStyle(fontSize: screenHeight * 0.015, letterSpacing: -0.3),
                            cursorHeight: screenHeight * 0.02,
                            cursorColor: Color.fromARGB(255, 155, 155, 156),
                          ),
                        ],
                      ),
                    ),
                    //Last Name Field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            "Last Name",
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
                                  "Last Name",
                                  value,
                                ),
                            controller: controller.lastName,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
                              label: Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "Enter your last name",
                                  style: TextStyle(
                                    letterSpacing: -0.3,
                                    fontSize: screenHeight * 0.015,
                                    color: Color.fromARGB(255, 155, 155, 156),
                                  ),
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              errorStyle: TextStyle(
                                color: AppColors.secondary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            style: TextStyle(fontSize: screenHeight * 0.015, letterSpacing: -0.3),
                            cursorHeight: screenHeight * 0.02,
                            cursorColor: Color.fromARGB(255, 155, 155, 156),
                          ),
                        ],
                      ),
                    ),
                    //Email Field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: screenHeight * 0.015,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          TextFormField(
                            validator:
                                (value) => AppValidator.validateEmail(value),
                            controller: controller.email,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
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
                              prefixIcon: Icon(CupertinoIcons.mail, size: screenHeight * 0.023,),
                              labelText: "Enter your email address",
                              labelStyle: TextStyle(
                                    letterSpacing: -0.3,
                                    fontSize: screenHeight * 0.015,
                                    color: Color.fromARGB(255, 155, 155, 156),
                                  ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              errorStyle: TextStyle(
                                color: AppColors.secondary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            style: TextStyle(fontSize: screenHeight * 0.015, letterSpacing: -0.3),
                            cursorHeight: screenHeight * 0.02,
                            cursorColor: Color.fromARGB(255, 155, 155, 156),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 40,),
                  //Continue Button
                  Container(
                    width: screenWidth * 0.88,
                    height: screenHeight * 0.0527,
                    decoration: BoxDecoration(
                      gradient: (controller.isValid.value && _formKey.currentState!.validate()) ? LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ) : LinearGradient(
                        colors: [Color.fromARGB(255, 160, 160, 160), Color.fromARGB(255, 160, 160, 160)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: OutlinedButton(
                      onPressed: controller.isValid.value ? 
                      (){
                        if(_formKey.currentState!.validate()){
                          Get.to(()=> SignUpPage3());
                        }
                      } : null,
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
                  SizedBox(height: 5,),
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
                                  Get.toNamed("/login");
                                },
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),
              brand(screenWidth, screenHeight)
            ],
          ),
        ),
      ),
    );
  }

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
