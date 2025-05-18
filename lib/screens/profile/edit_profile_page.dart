import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planago/utils/constants/colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  File? _imageFile;

  // Temporary variables habang wala pa data model + database
  // ifefetch yung current details para mapalitan
  String firstName = 'Myko Jefferson';
  String lastName = 'Javier';
  String phoneNumber = '997xxxxxxxx';

  //
  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              children: [
                editProfileText(screenWidth, screenHeight),
                Column(
                  // Separate Column for spacing only
                  spacing: screenHeight * 0.0183,
                  children: [
                    profilePicture(screenWidth, screenHeight),
                    firstNameField(screenWidth, screenHeight),
                    lastNameField(screenWidth, screenHeight),
                    phoneNumberField(screenWidth, screenHeight),
                    saveEditedProfile(screenWidth, screenHeight),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editProfileText(double width, double height) => Container(
    padding: EdgeInsets.zero,
    width: width * 0.88,
    height: height * 0.1226,
    child: SizedBox(
      width: width * 0.88,
      height: height * 0.1226,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox.square(
            dimension: width * 0.1224,
            child: IconButton(
              onPressed: Get.back,
              style: IconButton.styleFrom(padding: EdgeInsets.zero),
              icon: Icon(
                Iconsax.arrow_left,
                color: AppColors.primary,
                size: width * 0.0824,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Edit Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * 0.0252,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
          SizedBox.square(dimension: width * 0.1224),
        ],
      ),
    ),
  );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget profilePicture(double width, double height) {
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox.square(
        dimension: height * 0.1169, //102
        child: ClipOval(
          child:
              _imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : Image.asset(
                    'assets/images/default_profile.png',
                  ), // temp only
        ),
      ),
    );
  }

  Widget firstNameField(double width, double height) => Container(
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
              "First Name",
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextFormField(
            controller: firstNameController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: width * 0.0408,
              ),
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
              labelText: firstName,
              labelStyle: TextStyle(
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

  Widget lastNameField(double width, double height) => Container(
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
              "Last Name",
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextFormField(
            controller: firstNameController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: width * 0.0408,
              ),
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
              labelText: lastName,
              labelStyle: TextStyle(
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

  Widget phoneNumberField(double width, double height) => Container(
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
              "Phone Number",
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: TextFormField(
            controller: firstNameController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: width * 0.0408,
              ),
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
              labelText: "+63  |  $phoneNumber",
              labelStyle: TextStyle(
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

  Widget saveEditedProfile(double width, double height) => Container(
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
        /* SAVE PROFILE HERE*/
        Get.back(result: _imageFile);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.transparent),
      ),
      child: Text(
        "Save",
        style: TextStyle(
          color: AppColors.mutedWhite,
          fontSize: height * 0.023,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
