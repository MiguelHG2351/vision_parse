import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:vision_parse/pages/extract_page.dart';
import 'package:vision_parse/utils/storage_helper.dart';
import 'package:vision_parse/widgets/full_screen_image_screen.dart';
import 'package:vision_parse/widgets/image_detail_page.dart';
import 'package:go_router/go_router.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final List<FileSystemEntity> _historyFiles = [];
  
  @override
  void initState() {
    StorageHelper.loadHistoryFiles()
    .then((value) {
      print('Historial de imágenes cargado: $value');
      setState(() {
        _historyFiles.addAll(value);
      });
    });
    super.initState();
  }

  Future<String> _processImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String extractedText = recognizedText.text;
    // setState(() {
    //   _extractedText = extractedText;
    //   _ocrController.text = extractedText;
    // });
    textRecognizer.close();
    return extractedText;
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
                Text(
                  'Historial de imágenes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                if (_historyFiles.isEmpty)
                  const Text('No hay imágenes en el historial.')
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _historyFiles.length,
                    itemBuilder: (context, index) {
                      final file = _historyFiles[index];
                      if (file is! File) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: () async {
                          final result = await context.push('/image-detail', extra: {
                            'images': [file.path],
                            'currentIndex': 0,
                          });
                          if (!mounted || result == null || result is! Map || result['scan_again'] != true) return;
                          final extractedText = await _processImage(file.path);
                          context.push('/extract', extra: {
                            'imagePath': file.path,
                            'extractedText': extractedText,
                            'showSaveButton': false,
                          });
                        },
                        child: Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}