import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vision_parse/core/get_it.dart';
import 'package:vision_parse/pages/get_started_page.dart';
import 'package:vision_parse/pages/home_page.dart';
import 'package:vision_parse/pages/extract_page.dart';
import 'package:vision_parse/pages/settings_page.dart';
import 'package:vision_parse/pages/signin_page.dart';
import 'package:vision_parse/utils/shared_preferences_manager.dart';
import 'package:vision_parse/widgets/full_screen_image_screen.dart';
import 'package:vision_parse/widgets/image_detail_page.dart';
import 'package:vision_parse/widgets/shell_ui.dart';

final GoRouter router = GoRouter(
  // This is the initial route of the app
  initialLocation: GetStartedPage.path,
  redirect: (context, state) {
    final supabase = serviceLocator<SupabaseClient>();
    final supabaseSession = supabase.auth.currentSession;
    final isGuest = serviceLocator<SharedPreferencesManager>().getIsGuest() ?? false;
    print('Redirecting: isGuest: $isGuest, supabaseSession: ${supabaseSession != null}');

    // if the user is a guest or has a valid Supabase session, redirect to HomePage instead of GetStartedPage
    if ((isGuest || supabaseSession != null) && state.uri.path.contains(GetStartedPage.path)) {
      return HomePage.path;
    }
    return null;
  },
  routes: [
    GoRoute(
      name: GetStartedPage.pathName,
      path: GetStartedPage.path,
      builder: (context, state) => const GetStartedPage(),
    ),
    GoRoute(
      name: SigninPage.pathName,
      path: SigninPage.path,
      builder: (context, state) => const SigninPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        // goBranch(0)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomePage.path,
              name: HomePage.pathName,
              pageBuilder: (context, state) => NoTransitionPage(child: const HomePage()),
            ),
          ],
        ),
        // goBranch(1)
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'settings',
              path: '/settings',
              pageBuilder: (context, state) => NoTransitionPage(child: const SettingsPage()),
            ),
          ],
        )
      ],
      builder: (context, state, navigationShell) => ShellUi(navigationShell: navigationShell),
    ),
    // route with the result of the image extraction
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
    // route for displaying image details when an image is tapped
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
