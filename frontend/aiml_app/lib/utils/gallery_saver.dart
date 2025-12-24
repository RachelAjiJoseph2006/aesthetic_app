import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class GallerySaver {
  static const MethodChannel _channel =
      MethodChannel('com.yourapp.gallery_saver');

  /// Save [bytes] to a folder [folderName] in the gallery
  static Future<bool> saveImage(Uint8List bytes, String folderName, String filename) async {
    // Ask permission
    if (!await Permission.storage.request().isGranted) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod('saveImage', {
        'bytes': bytes,
        'folderName': folderName,
        'fileName': filename,
      });
      return result == true;
    } catch (e) {
      print("Error saving image: $e");
      return false;
    }
  }
}
