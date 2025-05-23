/*
  https://pub.dev/packages/image_gallery_saver  --to save qr code to gallery
  https://pub.dev/packages/render --to capture widget as image
  https://pub.dev/packages/qr_flutter --to generate qr code
*/
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/navigation_menu.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class QRCodeScreen extends StatefulWidget
{
  //create final travelplan obj
  final TravelPlan plan;

  const QRCodeScreen({super.key, required this.plan});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> 
{
  //global key for qr
  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;
  String? _username;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() 
  {
    _usernameController.dispose();
    super.dispose();
  }

  String _generateQRData() 
  {
    // Generate the data to be encoded in the QR code
    //id; title; destination; start date (yyyy-MM-ddTHH:mm:ss.mmmuuuZ); end date (yyyy-MM-ddTHH:mm:ss.mmmuuuZ)
    return "${widget.plan.id}";
  }

  // Save QR code to gallery
  Future<void> _saveQRToGallery() async 
  {
    setState(() 
    {
      _isSaving = true;
    });

    try 
    {
      // Capture the QR code as an image + renderrepaintboundary to minimize redundant work and improve app performance
      RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) 
      {
        final buffer = byteData.buffer.asUint8List();
        
        // Save to gallery
        await ImageGallerySaver.saveImage(buffer);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('QR Code saved to gallery'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } 
    
    catch (e) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save QR Code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } 
    
    finally 
    {
      setState(() 
      {
        _isSaving = false;
      });
    }
  }

  void _shareWithFriend() 
  {
    _usernameController.clear();
    showDialog(
      context: context,
      builder: (context) {
        String? usernameError;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Follower Username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'username_013',
                    border: OutlineInputBorder(),
                    errorText: usernameError,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ),
              TextButton(
                onPressed: () async 
                {
                  if (_usernameController.text.isEmpty) 
                  {
                    setState(() 
                    {
                      usernameError = 'Please enter a username.';
                    });
                    return;
                  } 
                  
                  else 
                  {
                    _username = _usernameController.text;

                    final userId = await TravelPlanDatabase.instance.getUserIdByUsername(_username!);
                    if (userId == null) 
                    {
                      setState(() 
                      {
                        usernameError = 'Follower not found.';
                      });
                      return;
                    }
                    
                    Navigator.pop(context);
                    final result = await TravelPlanDatabase.instance.addPeople(
                      widget.plan.id!,
                      userId,
                    );

                    if (result.contains("Already")) 
                    {
                      Get.snackbar(
                        "Fail",
                        'Travel plan already shared with $_username',
                        backgroundColor: Colors.amber,
                        colorText: Colors.black,
                      );
                    } 
                    
                    else 
                    {
                      Get.snackbar(
                        "Success",
                        'Travel plan shared with $_username',
                        backgroundColor: AppColors.primary,
                        colorText: Colors.black,
                      );
                    }

                    Get.offUntil(
                      MaterialPageRoute(builder: (_) => NavigationMenu()),
                      (route) => route.settings.name == '/navigation',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Travel plan shared with $_username'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(
                  'Share',
                  style: TextStyle(color: AppColors.mutedWhite),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) 
  {
    final width = Get.width;
    final height = Get.height;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Share Travel Plan",
          style: TextStyle(
            fontFamily: "Cal Sans",
            fontSize: height * 0.025,
            color: AppColors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: 
            [
              // Travel plan info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.mutedPrimary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
                  [
                    Text(
                      widget.plan.tripTitle,
                      style: TextStyle(
                        fontSize: height * 0.025,
                        fontFamily: "Cal Sans",
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: 
                      [
                        Icon(Icons.location_on, size: height * 0.02, color: AppColors.primary),
                        SizedBox(width: width * 0.01),
                        Text(
                          widget.plan.destination,
                          style: TextStyle(fontSize: height * 0.016),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: height * 0.04),
              
              // QR Code
              Text(
                "SCAN ME",
                style: TextStyle(
                  fontSize: height * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              
              // QR Code with repaint boundary for capturing
              RepaintBoundary(
                key: _qrKey,
                child: Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: 
                    [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: _generateQRData(),
                    version: QrVersions.auto,
                    size: width * 0.6,
                    backgroundColor: Colors.white,
                    // ignore: deprecated_member_use
                    foregroundColor: AppColors.black,
                    embeddedImage: MemoryImage(base64Decode(UserController.instance.user.value.avatar)),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(width * 0.1, width * 0.1),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: height * 0.04),
              
              // Save to gallery button
              SizedBox(
                width: width * 0.8,
                height: height * 0.06,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveQRToGallery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: _isSaving 
                      ? SizedBox(
                          width: width * 0.05,
                          height: width * 0.05,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.save_alt, color: AppColors.mutedWhite),
                  label: Text(
                    _isSaving ? "Saving..." : "Save to Gallery",
                    style: TextStyle(fontSize: height * 0.018),
                  ),
                ),
              ),
              
              SizedBox(height: height * 0.02),
              
              // Divider with "OR" text
              Row(
                children: 
                [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: AppColors.mutedBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: height * 0.02),
              
              // Share by username
              //TODO: find existing username in database and add travel plan id if not yet shared
              SizedBox(
                width: width * 0.8,
                height: height * 0.06,
                child: ElevatedButton.icon(
                  onPressed: _shareWithFriend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  icon: Icon(Icons.person_add, color: AppColors.primary),
                  label: Text(
                    "Share with a follower",
                    style: TextStyle(fontSize: height * 0.018),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
