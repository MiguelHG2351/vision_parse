import 'dart:io';

import 'package:flutter/material.dart';

class FullscreenImageScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;
  const FullscreenImageScreen({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 21),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(
              child: Image.file(
                File(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}