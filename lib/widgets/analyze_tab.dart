import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:vision_parse/pages/extract_page.dart';
import 'package:vision_parse/widgets/full_screen_image_screen.dart';
import '../utils/image_picker_helper.dart';
import 'dart:io';

class AnalyzeTab extends StatefulWidget {
  const AnalyzeTab({super.key});

  @override
  State<AnalyzeTab> createState() => _AnalyzeTabState();
}

class _AnalyzeTabState extends State<AnalyzeTab> {
  File? _selectedImage;
  bool isProcessing = false;

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePickerHelper.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await ImagePickerHelper.takePhoto();

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFilePath(_selectedImage!.path);
    final textRecognizer = TextRecognizer();
    setState(() {
      isProcessing = true;
    });
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String extractedText = recognizedText.text;
    // setState(() {
    //   _extractedText = extractedText;
    //   _ocrController.text = extractedText;
    // });
    textRecognizer.close();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExtractPage(imagePath: _selectedImage!.path, extractedText: extractedText),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
                if (_selectedImage != null)
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenImageScreen(
                                imageUrl: _selectedImage!.path,
                                tag: 'imageHero',
                              ),
                            ),
                          );
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 350,
                            minWidth: double.infinity,
                          ),
                          child: Hero(
                            tag: 'imageHero',
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/camera_icon.svg',
                        width: 60,
                        height: 60,
                      ),
                      Text(
                        'Capture text',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'Take a photo or select an image from your gallery',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                if (_selectedImage == null)
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: _takePhoto,
                          child: Text('Tomar foto', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: _pickImageFromGallery,
                          child: Text('Elegir de la galería', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                        ),
                      )
                    ],
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: _processImage,
                          child: Text(
                            'Extraer texto',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text('Clear', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
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
