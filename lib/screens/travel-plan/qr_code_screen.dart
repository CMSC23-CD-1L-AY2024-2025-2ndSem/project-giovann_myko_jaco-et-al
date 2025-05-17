import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class QRCodeScreen extends StatefulWidget 
{
  final TravelPlan plan;

  const QRCodeScreen({Key? key, required this.plan}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> 
{
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
    return "${widget.plan.id}|${widget.plan.tripTitle}|${widget.plan.destination}";
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
      RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) 
      {
        final buffer = byteData.buffer.asUint8List();
        
        // Save to gallery
        final result = await ImageGallerySaver.saveImage(buffer);
        
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

  // Share with a friend by username
  void _shareWithFriend() 
  {
    if (_username == null || _username!.isEmpty) 
    {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enter Username'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Friend\'s username',
              border: OutlineInputBorder(),
            ),
          ),
          actions: 
          [
            TextButton(
              onPressed: () 
              {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () 
              {
                setState(() 
                {
                  _username = _usernameController.text;
                });
                Navigator.pop(context);
                // Here you would implement the actual sharing logic
                // This would typically involve a backend call
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Travel plan shared with $_username'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: Text('Share'),
            ),
          ],
        ),
      );
    } 
    
    else 
    {
      // Implement sharing with the already entered username
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Travel plan shared with $_username'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
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
                "Scan this QR code to share",
                style: TextStyle(
                  fontSize: height * 0.02,
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
                    foregroundColor: AppColors.primary,
                    embeddedImage: AssetImage('assets/images/default_profile.png'),
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
                      : Icon(Icons.save_alt),
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
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: height * 0.02),
              
              // Share by username
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
                  icon: Icon(Icons.person_add),
                  label: Text(
                    "Share with Friend by Username",
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
