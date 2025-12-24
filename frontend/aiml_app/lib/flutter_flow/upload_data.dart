// lib/flutter_flow/upload_data.dart
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

enum MediaSource { photoGallery, camera }

class FFUploadedFile {
  final String name;
  final Uint8List? bytes;
  final int? height;
  final int? width;
  final String? blurHash;
  final String? originalFilename;

  FFUploadedFile({
    required this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
    this.originalFilename,
  });
}

/// A small wrapper used by the original FlutterFlow code.
/// We return a list with either one or multiple selected items.
class SelectedMedia {
  final String storagePath;
  final Uint8List? bytes;
  final Size? dimensions;
  final String? blurHash;
  final String? originalFilename;

  SelectedMedia({
    required this.storagePath,
    this.bytes,
    this.dimensions,
    this.blurHash,
    this.originalFilename,
  });
}

/// Shows system camera/gallery and returns list of SelectedMedia or null.
Future<List<SelectedMedia>?> selectMedia({
  MediaSource mediaSource = MediaSource.photoGallery,
  int imageQuality = 100,
  bool multiImage = false,
}) async {
  final ImagePicker picker = ImagePicker();
  try {
    if (multiImage) {
      final List<XFile>? files = await picker.pickMultiImage(
        imageQuality: imageQuality,
      );
      if (files == null || files.isEmpty) return null;
      return Future.wait(files.map((f) async {
        final bytes = await f.readAsBytes();
        // We don't compute dimensions here to keep it simple.
        return SelectedMedia(
          storagePath: f.path,
          bytes: bytes,
          dimensions: null,
          originalFilename: f.name,
        );
      }));
    } else {
      final XFile? file = (mediaSource == MediaSource.photoGallery)
          ? await picker.pickImage(source: ImageSource.gallery, imageQuality: imageQuality)
          : await picker.pickImage(source: ImageSource.camera, imageQuality: imageQuality);

      if (file == null) return null;
      final bytes = await file.readAsBytes();
      return [
        SelectedMedia(
          storagePath: file.path,
          bytes: bytes,
          dimensions: null,
          originalFilename: file.name,
        )
      ];
    }
  } catch (e) {
    // ignore errors and return null
    return null;
  }
}

/// Very small validator - checks extension against typical image types.
bool validateFileFormat(String? path, BuildContext context) {
  if (path == null) return false;
  final lower = path.toLowerCase();
  return lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.webp');
}
