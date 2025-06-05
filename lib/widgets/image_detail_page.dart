import 'dart:io';

import 'package:flutter/material.dart';

/// A page that displays the image detail
class ImageDetailPage extends StatefulWidget {
  /// Constructor used to initialize the [ImageDetailPage]
  const ImageDetailPage({
    super.key,
    required this.images,
    required this.currentIndex,
  });

  /// Property used to handle by routing by pathName
  static String pathName = 'image-detail';

  /// Property used to handle by routing by path
  static String path = '/image-detail';

  /// The images to display
  final List<String> images;

  /// The current index of the image
  final int currentIndex;

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  final _transformationController = TransformationController();
  final _pageController = PageController();
  late Matrix4 initialControllerValue;
  late int currentIndex;
  double _componentsOpactiy = 1;

  @override
  void initState() {
    currentIndex = widget.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(widget.currentIndex);
    });

    _transformationController.addListener(() {
      if (_transformationController.value.getMaxScaleOnAxis() == 1.0) {
        setState(() {
          _componentsOpactiy = 1;
        });
      } else {
        setState(() {
          _componentsOpactiy = 0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dismissible(
        key: const ValueKey('image-detail'),
        onDismissed: (_) => Navigator.pop(context),
        direction: DismissDirection.vertical,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 39, 39, 21),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  top: kToolbarHeight + 20.0,
                  bottom: kBottomNavigationBarHeight + 20.0,
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    transformationController: _transformationController,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      children: [
                        for (final image in widget.images)
                          GestureDetector(
                            onDoubleTap: () {
                              _transformationController.value = Matrix4.identity();
                            },
                            child: Image.file(
                              File(image),
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Align(
                //   alignment: AlignmentDirectional.topCenter,
                //   child: AnimatedOpacity(
                //     opacity: _componentsOpactiy,
                //     duration: const Duration(milliseconds: 300),
                //     child: DialogAppbar(
                //       avatarUrl: widget.post.account.profilePictureUrl,
                //       title: widget.post.account.fullName,
                //     ),
                //   ),
                // ),,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: _componentsOpactiy,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context, {
                                'scan_again': true,
                              });
                            },
                            child: const Text('Escanear de nuevo'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
