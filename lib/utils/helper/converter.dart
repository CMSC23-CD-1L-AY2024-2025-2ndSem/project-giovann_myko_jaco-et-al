import 'dart:convert';
import 'package:flutter/services.dart' show Uint8List, rootBundle;


class AppConvert {

  //Convert Asset to Base64
  static Future<String> convertAssetToBase64(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();
  return base64Encode(bytes);
  }

  static Uint8List base64toImage (String base64String){
    return base64Decode(base64String);
  }
}