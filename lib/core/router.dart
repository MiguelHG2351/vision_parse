import 'package:go_router/go_router.dart';
import 'package:vision_parse/pages/home_page.dart';
import 'package:vision_parse/pages/extract_page.dart';
import 'package:vision_parse/widgets/full_screen_image_screen.dart';
import 'package:vision_parse/widgets/image_detail_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/extract',
      builder: (context, state) {
        final imagePath = state.extra is Map ? (state.extra as Map)['imagePath'] as String : '';
        final extractedText = state.extra is Map ? (state.extra as Map)['extractedText'] as String : '';
        final showSaveButton = state.extra is Map ? (state.extra as Map)['showSaveButton'] as bool? ?? true : true;
        return ExtractPage(imagePath: imagePath, extractedText: extractedText, showSaveButton: showSaveButton);
      },
    ),
    GoRoute(
      path: '/fullscreen',
      builder: (context, state) {
        final imageUrl = state.extra is Map ? (state.extra as Map)['imageUrl'] as String : '';
        final tag = state.extra is Map ? (state.extra as Map)['tag'] as String : '';
        return FullscreenImageScreen(imageUrl: imageUrl, tag: tag);
      },
    ),
    GoRoute(
      path: '/image-detail',
      builder: (context, state) {
        final images = state.extra is Map ? List<String>.from((state.extra as Map)['images'] ?? []) : <String>[];
        final currentIndex = state.extra is Map ? (state.extra as Map)['currentIndex'] as int : 0;
        return ImageDetailPage(images: images, currentIndex: currentIndex);
      },
    ),
  ],
);
