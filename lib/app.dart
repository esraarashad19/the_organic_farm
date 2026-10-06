
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organic_farm_copy/core/utils/app_update_service.dart';

import 'app_router.dart';
import 'core/l10n/app_localizations.dart';
import 'core/session/session.dart';
import 'core/theme/app_theme.dart';

class OrganicFarmApp extends ConsumerWidget {
  const OrganicFarmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (!session.ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Organic Farm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),

      locale: session.locale,

      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: router,

      builder: (context, child) {
        return Directionality(
          textDirection:
          session.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: _UpdateChecker(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class _UpdateChecker extends StatefulWidget {
  const _UpdateChecker({
    required this.child,
  });

  final Widget child;

  @override
  State<_UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<_UpdateChecker> {
  bool _checked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_checked) {
      _checked = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        AppUpdateService.checkForUpdate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
