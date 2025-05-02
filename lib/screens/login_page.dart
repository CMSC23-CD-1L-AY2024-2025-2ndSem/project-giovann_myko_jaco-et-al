import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/sizes.dart';

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
              children: [loginText, usernameField, passwordField, loginOptions],
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
                onPressed: () {},
                icon: Icon(
                  Iconsax.eye,
                  size: 18,
                  color: Color.fromARGB(255, 155, 155, 156),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            obscureText: true,
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

}
