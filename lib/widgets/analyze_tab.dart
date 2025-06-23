import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:go_router/go_router.dart';
import '../utils/image_picker_helper.dart';
import 'dart:io';

class AnalyzeTab extends StatefulWidget {
  const AnalyzeTab({super.key});

  @override
  State<AnalyzeTab> createState() => _AnalyzeTabState();
}

class _AnalyzeTabState extends State<AnalyzeTab> {
  File? _selectedImage;
  File? _originalImage;
  bool isProcessing = false;

  Future<void> _pickImageFromGallery() async {
    final result = await ImagePickerHelper.pickImageFromGallery();
    if (result != null) {
      setState(() {
        _selectedImage = result.cropped;
        _originalImage = result.original;
      });
    }
  }

  Future<void> _takePhoto() async {
    final result = await ImagePickerHelper.takePhoto();
    if (result != null) {
      setState(() {
        _selectedImage = result.cropped;
        _originalImage = result.original;
      });
    }
  }

  Future<void> _cropImageAgain() async {
    if (_originalImage != null) {
      final cropped = await ImagePickerHelper.cropImage(_originalImage!);
      if (cropped != null) {
        setState(() {
          _selectedImage = cropped;
        });
      }
    }
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFilePath(_selectedImage!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    setState(() {
      isProcessing = true;
    });
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String extractedText = recognizedText.text;
    textRecognizer.close();
    if (!mounted) return;
    context.push('/extract', extra: {
      'imagePath': _selectedImage!.path,
      'extractedText': extractedText,
    });
    setState(() {
      isProcessing = false;
    });
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
                          context.push('/fullscreen', extra: {
                            'imageUrl': _selectedImage!.path,
                            'tag': 'imageHero',
                          });
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
                        'Captura o selecciona una imagen',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Toma una foto o selecciona una imagen de tu galería',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                if (_selectedImage == null)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
                            backgroundColor: WidgetStateProperty.all(Colors.orange),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: _takePhoto,
                          child: Text('Tomar foto', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
                            backgroundColor: WidgetStateProperty.all(Colors.orange),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: _pickImageFromGallery,
                          child: Text('Elegir de la galería', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
                                backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2);
                                    }
                                    return null;
                                  },
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: _cropImageAgain,
                              child: Text(
                                'Recortar imagen',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
                                backgroundColor: WidgetStateProperty.all(Colors.orange),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.2);
                                    }
                                    return null;
                                  },
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: _processImage,
                              child: Text(
                                'Extraer texto',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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
