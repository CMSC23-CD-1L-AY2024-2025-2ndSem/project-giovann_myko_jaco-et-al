import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/components/app_bar_return.dart';
import 'package:planago/controllers/signup_controller.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/authentication/login/login_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUpPage3 extends StatelessWidget {
  const SignUpPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final screenHeight = Get.height;
    final screenWidth = Get.width;
    return Obx(
      () => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarReturn(),
                //Header
                Padding(
                  padding: const EdgeInsets.only(left: 9, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Show us your ",
                            style: TextStyle(
                              fontSize: Get.height * 0.0401,
                              fontFamily: 'Cal Sans',
                              color: AppColors.black,
                            ),
                          ),
                          GradientText(
                            "Style!",
                            style: TextStyle(
                              fontSize: Get.height * 0.0401,
                              fontFamily: 'Cal Sans',
                            ),
                            colors: [AppColors.primary, AppColors.secondary],
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ltr,
                          ),
                        ],
                      ),
                      Text(
                        "Lets us know your interest and preferred traveling style!",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          fontSize: Get.height * 0.015,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                //Interests
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Interests",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          fontSize: Get.height * 0.020,
                        ),
                      ),
                      Text(
                        "Select all the applies",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.3,
                          fontSize: Get.height * 0.014,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children:
                            UserModel.setInterests.map((interest) {
                              final isSelected = controller.interests.contains(
                                interest,
                              );
                              return FilterChip(
                                
                                label: Text(interest),
                                selected: isSelected,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.interests.add(interest);
                                  } else {
                                    controller.interests.remove(interest);
                                  }
                                },
                                labelStyle: TextStyle(fontSize: Get.height * 0.014, letterSpacing: -0.3, color: isSelected ? AppColors.mutedWhite : AppColors.black),
                                selectedColor: AppColors.secondary,
                                backgroundColor: Color(0xffF5F7FB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide.none,
                                ),
                                labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                //Travel Styles
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Travel Styles",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          fontSize: Get.height * 0.020,
                        ),
                      ),
                      Text(
                        "Select all the applies",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.3,
                          fontSize: Get.height * 0.014,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children:
                            UserModel.settravelStyles.map((style) {
                              final isSelected = controller.travelStyles.contains(
                                style,
                              );
                              return FilterChip(
                                
                                label: Text(style),
                                selected: isSelected,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.travelStyles.add(style);
                                  } else {
                                    controller.travelStyles.remove(style);
                                  }
                                },
                                labelStyle: TextStyle(fontSize: Get.height * 0.014, letterSpacing: -0.3, color: isSelected ? AppColors.mutedWhite : AppColors.black),
                                selectedColor: AppColors.secondary,
                                backgroundColor: Color(0xffF5F7FB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide.none,
                                ),
                                labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ), 
                  SizedBox(height: 20),
                 //Continue Button
                  Column(
                    children: [
                      Container(
                        width: screenWidth * 0.88,
                        height: screenHeight * 0.0527,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: OutlinedButton(
                          onPressed:() async {
                            await controller.signUp();
                            Get.to(NavigationMenu());
                          },
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
                                  Get.offAll(() => LoginPage());
                                },
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
