import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class PickedImageResult {
  final File original;
  final File cropped;

  PickedImageResult({required this.original, required this.cropped});
}

class ImagePickerHelper {
  static Future<PickedImageResult?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1920,
      );

      if (pickedFile != null) {
        final original = File(pickedFile.path);
        final croppedFile = await _cropImage(original);
        if (croppedFile != null) {
          return PickedImageResult(original: original, cropped: croppedFile);
        }
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<PickedImageResult?> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final original = File(pickedFile.path);
      final croppedFile = await _cropImage(original);
      if (croppedFile != null) {
        return PickedImageResult(original: original, cropped: croppedFile);
      }
    }
    return null;
  }

  static Future<File?> cropImage(File imageFile) async {
    return await _cropImage(imageFile);
  }

  static Future<File?> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return imageFile;
    } catch (e) {
      print('Error cropping image: $e');
      return imageFile;
    }
  }
}
