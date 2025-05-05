import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Temporary variables habang wala pa data model + database
  bool rememberMe = false;
  bool isPasswordObscured = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /* 
      responsive UI - for phones only
      -------------------------------
      - percentages calculated using standard phone size
      multiplied with wireframe dimensions and/or utils/constant

      Common fontSize {
        fonts relative to height
        13 => 1.5%
        12 => 1.38%
        16 => 1.83%
        20 => 2.3%
        35 => 4.01%
      }

      Icons: 18 => 2% 

      Main Container {
        left and right padding: 6% each
        remaining phone width: 88%
        spacing: AppSizes.spaceBtwItems => 1.83%
      }

      loginText {
        width: 88%
        height: 22%
      }

      usernameField & passwordField{
        width: 88%
        height: 6.5%
        cursorHeight: 18 => 2%
      }

      loginOptions {
        width: 88%
        height: 3.9%
        cursorHeight: 18 => 2%
      }

      signIn {
        width: 88%
        height: 5.27%
      }

      divider {
        width: 88%
        height: 1.8%
        Divider indent: 3.06%
        Divider endIndent: 2.04%
      }

      googleSignIn {
        width: 88%
        height: 9.15%
        OutlinedButton height: 5.27%
        Sign up TextButton: 3.7%
      }

      brand {
        width: 88%
        height: 32.07% - remaining phone height
      }
      -------------------------------

    
    */
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.mutedWhite,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: screenHeight * 0.0183,
              children: [
                loginText(screenWidth, screenHeight),
                usernameField(screenWidth, screenHeight),
                passwordField(screenWidth, screenHeight),
                loginOptions(screenWidth, screenHeight),
                signIn(screenWidth, screenHeight),
                divider(screenWidth, screenHeight),
                googleSignIn(screenWidth, screenHeight),
                brand(screenWidth, screenHeight),
              ],
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
          letterSpacing: -0.5
        ),
      ),
    ),
  );

  Widget usernameField(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.065,
    child: Column(
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(
            width: width * 0.88,
            child: Text(
              "Username",
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.3
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextFormField(
            controller: usernameController,
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
                size: height * 0.02,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              labelText: "Enter your username",
              labelStyle: TextStyle(
                letterSpacing: -0.3,
                fontSize: height * 0.015,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            style: TextStyle(fontSize: height * 0.015),
            cursorHeight: height * 0.02,
            cursorColor: Color.fromARGB(255, 155, 155, 156),
          ),
        ),
      ],
    ),
  );

  Widget passwordField(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.065,
    child: Column(
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(
            width: width * 0.88,
            child: Text(
              "Password",
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextFormField(
            controller: passwordController,
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
                size: height * 0.02,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                fontSize: height * 0.015,
                letterSpacing: -0.3,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordObscured = !isPasswordObscured;
                  });
                },
                icon: Icon(
                  isPasswordObscured ? Iconsax.eye : Iconsax.eye_slash,
                  size: height * 0.02,
                  color: Color.fromARGB(255, 155, 155, 156),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            obscureText: isPasswordObscured,
            style: TextStyle(fontSize: height * 0.015),
            cursorHeight: height * 0.02,
            cursorColor: Color.fromARGB(255, 155, 155, 156),
          ),
        ),
      ],
    ),
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
              value: rememberMe,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(
                color: Color.fromARGB(255, 155, 155, 156),
                width: 1.5,
              ),
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  rememberMe = value!;
                });
              },
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
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(100),
    ),
    child: OutlinedButton(
      onPressed: () {},
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
            onPressed: () {},
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
                  fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed("/signup");
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
