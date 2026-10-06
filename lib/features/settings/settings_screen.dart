import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/session/session.dart';
import '../../core/widgets/app_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return FarmScaffold(
      title: l10n.settingsTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: FarmCard(
          child: Column(
            children: [
              SettingsRow(
                icon: AppAssets.user,
                label: l10n.profileButton,
                onTap: () => context.push('/profile'),
              ),
              SettingsRow(
                icon: AppAssets.language,
                label: l10n.changeLanguage,
                onTap: () => context.push('/language'),
              ),
              SettingsRow(
                icon: AppAssets.logout,
                label: l10n.logout,
                onTap: () async {
                  await ref.read(sessionProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
