
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/session/session.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/contact/contact_screen.dart';
import 'features/contracts/contracts_screen.dart';
import 'features/contracts/pdf_viewer_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/finance/finance_screen.dart';
import 'features/land/land_screen.dart';
import 'features/language/language_screen.dart';
import 'features/media/image_detail_screen.dart';
import 'features/media/media_screen.dart';
import 'features/media/video_player_screen.dart';
import 'features/operations/operations_screen.dart';
import 'features/production/production_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';


final rootNavigatorKey = GlobalKey<NavigatorState>();


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
// Always start from login if language has already been selected.
// If language hasn't been selected yet, start from language screen.
    initialLocation: () {
      final session = ref.read(sessionProvider);

      if (!session.hasChosenLanguage) {
        return '/language';
      }

      return '/login';
    }(),

    refreshListenable: _SessionRefresh(ref),

    redirect: (context, state) {
      final session = ref.read(sessionProvider);

      if (!session.ready) return null;

      final location = state.matchedLocation;

      final loggingIn = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location == '/language';

// Language hasn't been selected yet.
      if (!session.hasChosenLanguage && location != '/language') {
        return '/language';
      }

// User is not logged in and trying to access a protected screen.
      if (!session.isLoggedIn && !loggingIn) {
        return '/login';
      }

// No redirect for logged-in users.
// This allows the app to start at /login every time.
      return null;
    },

    routes: [
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageScreen(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: '/land',
        builder: (context, state) => const LandScreen(),
      ),

      GoRoute(
        path: '/contracts',
        builder: (context, state) => const ContractsScreen(),
      ),

      GoRoute(
        path: '/pdf',
        builder: (context, state) => PdfViewerScreen(
          url: state.uri.queryParameters['url'] ?? '',
          withTitle: bool.parse(state.uri.queryParameters['withTitle']??'true'),
        ),
      ),

      GoRoute(
        path: '/image',
        builder: (context, state) => ImageDetailScreen(
          url: state.uri.queryParameters['url'] ?? '',
        ),
      ),

      GoRoute(
        path: '/video',
        builder: (context, state) => VideoPlayerScreen(
          url: state.uri.queryParameters['url'] ?? '',
        ),
      ),

      GoRoute(
        path: '/operations',
        builder: (context, state) => const OperationsScreen(),
      ),

      GoRoute(
        path: '/production',
        builder: (context, state) => const ProductionScreen(),
      ),

      GoRoute(
        path: '/finance',
        builder: (context, state) => const FinanceScreen(),
      ),

      GoRoute(
        path: '/media',
        builder: (context, state) => const MediaScreen(),
      ),

      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
    ],
  );
});

class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(this.ref) {
    ref.listen(sessionProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref ref;
}



