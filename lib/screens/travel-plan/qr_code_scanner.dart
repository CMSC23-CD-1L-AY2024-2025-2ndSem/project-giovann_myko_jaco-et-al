import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRScannerScreen> 
{
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() 
  {
    super.reassemble();
    if (Platform.isAndroid) 
    {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) 
  {
    final height = Get.height;
    return Scaffold(
            appBar: AppBar(
        title: Text(
          "Scan QR code",
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
      body: Column(
        children: <Widget>
        [
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                      style: TextStyle(
                        fontFamily: "Cal Sans",
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    )

                  else
                    Text(
                      'Scan a code',
                      style: TextStyle(
                        fontFamily: "Cal Sans",
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>
                  [
                    IconButton(
                      onPressed: () async 
                      {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      icon: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) 
                        {
                          final isOn = snapshot.data == true || snapshot.data == 'on';
                          return Icon(
                            isOn ? Icons.flash_on : Icons.flash_off,
                            color: AppColors.primary,
                            size: 15,
                          );
                        },
                      ),
                      tooltip: 'Flash',
                      iconSize: 28,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      onPressed: () async 
                      {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      icon: FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) 
                        {
                          if (snapshot.data != null) 
                          {
                            final isBack = describeEnum(snapshot.data!) == 'back';
                            return Icon(
                              isBack ? Icons.camera_rear : Icons.camera_front,
                              color: AppColors.primary,
                              size: 15,
                            );
                          } 
                          
                          else 
                          {
                            return Icon(Icons.camera, color: AppColors.primary, size: 15);
                          }
                        },
                      ),
                      tooltip: 'Switch Camera',
                      iconSize: 28,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      onPressed: () async 
                      {
                        await controller?.pauseCamera();
                      },
                      icon: Icon(Icons.pause, color: AppColors.primary, size: 15),
                      tooltip: 'Pause',
                      iconSize: 28,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      onPressed: () async 
                      {
                        await controller?.resumeCamera();
                      },
                      icon: Icon(Icons.play_arrow, color: AppColors.primary, size: 15),
                      tooltip: 'Resume',
                      iconSize: 28,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) 
  {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: AppColors.primary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) 
  {
    setState(() 
    {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async 
    {
      if (result == null) 
      {
        setState(() 
        {
          result = scanData;
        });
        await controller.pauseCamera();
        try 
        {
          await TravelPlanDatabase.instance.addPeople(
            result!.code!,
            AuthenticationController.instance.authUser!.uid,
          );
          Get.snackbar("Success", "Successfully Added");
          Get.offUntil(
                    MaterialPageRoute(builder: (_) => NavigationMenu()),
                    (route) => route.settings.name == '/navigation',
          );
          TravelPlanDatabase.instance.listenToTravelPlans();
        } 
        
        catch (e) 
        {
          Get.snackbar("ERROR", "Scan failed: $e");
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) 
  {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');Get.snackbar("TRAVEL ID", result!.code!);
    if (!p) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}