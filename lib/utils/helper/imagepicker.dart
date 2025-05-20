import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/screens/profile/choose_avatar_page.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();
  
  static Future<void> pickProfileImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Choose from default avatar'),
                onTap: () {
                  Get.to(() => ChooseAvatarPage()); // Placeholder action
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Use Camera'),
                onTap: () async {
                  Get.back();
                  XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (image != null) {
                    final file = File(image.path);

                    final compressedBytes =
                        await FlutterImageCompress.compressWithFile(
                          file.absolute.path,
                          minWidth: 400,
                          minHeight: 400,
                          quality: 70,
                        );

                    if (compressedBytes != null) {
                      final base64Profile = base64Encode(compressedBytes);

                      final userDetails = UserController.instance.user;
                      final user = userDetails.value.copyWith(
                        avatar: base64Profile,
                      );

                      final controller = UserController.instance;
                      controller.editUserProfile(user);
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () async {
                  Get.back();
                  XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (image != null) {
                    final file = File(image.path);

                    final compressedBytes =
                        await FlutterImageCompress.compressWithFile(
                          file.absolute.path,
                          minWidth: 400,
                          minHeight: 400,
                          quality: 70,
                        );

                    if (compressedBytes != null) {
                      final base64Profile = base64Encode(compressedBytes);

                      final userDetails = UserController.instance.user;
                      final user = userDetails.value.copyWith(
                        avatar: base64Profile,
                      );

                      final controller = UserController.instance;
                      controller.editUserProfile(user);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}