import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          context.pop();
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