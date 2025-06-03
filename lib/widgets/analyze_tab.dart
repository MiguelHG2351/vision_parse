import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/image_picker_helper.dart';
import 'dart:io';

class AnalyzeTab extends StatefulWidget {
  const AnalyzeTab({Key? key}) : super(key: key);

  @override
  State<AnalyzeTab> createState() => _AnalyzeTabState();
}

class _AnalyzeTabState extends State<AnalyzeTab> {
  File? _selectedImage;

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePickerHelper.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      // TODO: Implement image processing logic here
    }
  }

  Future<void> _takePhoto() async {
    // TODO: Implement camera functionality
    // This will be similar to gallery but using ImageSource.camera
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/camera_icon.svg',
                  width: 60,
                  height: 60,
                ),
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                Text(
                  'Capture text',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Take a photo or select an image from your gallery',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _takePhoto,
                        child: Text('Take photo'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickImageFromGallery,
                        child: Text('Choose from gallery'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
