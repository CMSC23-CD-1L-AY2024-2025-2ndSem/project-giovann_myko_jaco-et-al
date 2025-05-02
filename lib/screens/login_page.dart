import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/sizes.dart';
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
    return Scaffold(
      backgroundColor: AppColors.mutedWhite,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: AppSizes.defaultSpace,
            right: AppSizes.defaultSpace,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSizes.spaceBtwItems,
              children: [
                loginText,
                usernameField,
                passwordField,
                loginOptions,
                signIn,
                divider,
                googleSignIn,
                brand,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get loginText => Container(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 87),
    width: 338,
    height: 194,
    child: Center(
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ),
    ),
  );

  Widget get usernameField => Container(
    padding: EdgeInsets.zero,
    width: 338,
    height: 58,
    child: Column(
      children: [
        SizedBox(
          height: 20,
          width: double.maxFinite,
          child: Text(
            "Username",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 38,
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
                size: 18,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              labelText: "Enter your username",
              labelStyle: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            style: TextStyle(fontSize: 13),
            cursorHeight: 18,
            cursorColor: Color.fromARGB(255, 155, 155, 156),
          ),
        ),
      ],
    ),
  );

  Widget get passwordField => Container(
    padding: EdgeInsets.zero,
    width: 338,
    height: 58,
    child: Column(
      children: [
        SizedBox(
          height: 20,
          width: double.maxFinite,
          child: Text(
            "Password",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 38,
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
                size: 18,
                color: Color.fromARGB(255, 155, 155, 156),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                fontSize: 13,
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
                  size: 18,
                  color: Color.fromARGB(255, 155, 155, 156),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            obscureText: isPasswordObscured,
            style: TextStyle(fontSize: 13),
            cursorHeight: 18,
            cursorColor: Color.fromARGB(255, 155, 155, 156),
          ),
        ),
      ],
    ),
  );

  Widget get loginOptions => Container(
    padding: EdgeInsets.zero,
    width: 332,
    height: 34, // adjusted, hindi nakikita text button kapag 18px
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
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              onChanged: (value) {
                setState(() {
                  rememberMe = value!;
                });
              },
            ),
            Text(
              "Remember me",
              style: TextStyle(
                fontSize: 12,
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    ),
  );

  Widget get signIn => Container(
    width: 338,
    height: 46,
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
          color: AppColors.mutedWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget get divider => SizedBox(
    width: 338,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Divider(color: Color(0xFF2a2a2a), indent: 12, endIndent: 8),
        ),
        Text(
          "or",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2a2a2a),
          ),
        ),
        Expanded(
          child: Divider(color: Color(0xFF2a2a2a), indent: 12, endIndent: 8),
        ),
      ],
    ),
  );

  Widget get googleSignIn => Container(
    padding: EdgeInsets.zero,
    width: 338,
    height: 80,
    child: Column(
      children: [
        SizedBox(
          height: 46,
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
                  width: 25,
                  height: 26,
                ),
                SizedBox(width: 46),
                Text(
                  "Continue with Google",
                  style: TextStyle(
                    color: Color.fromARGB(255, 82, 82, 82),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 338,
          height: 34,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Color.fromARGB(255, 82, 82, 82),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 82, 82, 82),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget get brand => SizedBox(
    height: 280,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /* logo here */
        GradientText(
          "PlanaGo",
          style: TextStyle(fontSize: 35, fontFamily: 'Cal Sans'),
          colors: [AppColors.primary, AppColors.secondary],
          gradientType: GradientType.linear,
          gradientDirection: GradientDirection.ltr,
        ),
      ],
    ),
  );
}
