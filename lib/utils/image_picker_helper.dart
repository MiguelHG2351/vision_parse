import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerHelper {
  static Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1920,
      );

      if (pickedFile != null) {
        final croppedFile = await _cropImage(File(pickedFile.path));
        return croppedFile;
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
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
