import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    final email = emailController.text.trim();
    if (!Validators.isEmail(email)) {
      showAppMessage(context, 'Invalid email format', error: true);
      return;
    }
    setState(() => loading = true);
    try {
      final message = await ref.read(authRepositoryProvider).forgotPassword(email);
      if (!mounted) return;
      showAppMessage(context, message);
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FarmScaffold(
      authBackground: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          children: [
            const BrandLogo(height: 72),
            const SizedBox(height: 16),
            Text(
              l10n.forgotPasswordTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            AppField(
              label: l10n.emailLabel,
              controller: emailController,
              hint: l10n.emailPlaceholder,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: l10n.reset, onPressed: _reset, loading: loading),
          ],
        ),
      ),
    );
  }
}
