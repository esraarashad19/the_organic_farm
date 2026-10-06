import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/session/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loggedIn = ref.watch(sessionProvider).isLoggedIn;

    Future<void> select(String code) async {
      await ref.read(sessionProvider.notifier).setLanguage(Locale(code));
      if (!context.mounted) return;
      if (loggedIn) {
        context.go('/dashboard');
      } else {
        context.go('/login');
      }
    }

    return FarmScaffold(
      authBackground: true,
      showClose: loggedIn,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const BrandLogo(height: 92),
            const SizedBox(height: 48),
            Text(
              l10n.selectLang,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.title,
              ),
            ),
            const SizedBox(height: 36),
            PrimaryButton(
              label: l10n.english,
              color: AppColors.english,
              onPressed: () => select('en'),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: l10n.arabic,
              onPressed: () => select('ar'),
            ),
          ],
        ),
      ),
    );
  }
}
