import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/session/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);
    final email = emailController.text.trim();
    final password = passwordController.text;
    final error = Validators.loginError(email, password);
    if (error != null) {
      final message = error == 'email_required'
          ? l10n.emailRequired
          : error == 'password_required'
              ? l10n.passwordRequired
              : error;
      showAppMessage(context, message, error: true);
      return;
    }

    setState(() => loading = true);
    try {
      await ref.read(authRepositoryProvider).login(email: email, password: password);
      if (!mounted) return;
      showAppMessage(context, l10n.loginSuccess);
      context.go('/dashboard');
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppMessage(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      showAppMessage(context, l10n.loginError, error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _toggleLanguage() async {
    final arabic = ref.read(sessionProvider).isArabic;
    await ref.read(sessionProvider.notifier).setLanguage(
          arabic ? const Locale('en') : const Locale('ar'),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(sessionProvider).isArabic;

    return FarmScaffold(
      authBackground: true,
      showClose: false,
      child: LoadingOverlay(
        visible: loading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const BrandLogo(height: 86),
              const SizedBox(height: 28),
              Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.title,
                ),
              ),
              const SizedBox(height: 28),
              AppField(
                label: l10n.emailLabel,
                controller: emailController,
                hint: l10n.emailPlaceholder,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppField(
                label: l10n.passwordLabel,
                controller: passwordController,
                hint: l10n.passwordPlaceholder,
                obscure: obscure,
                suffix: IconButton(
                  onPressed: () => setState(() => obscure = !obscure),
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: Text(
                    l10n.forgotPassword,
                    style: const TextStyle(color: AppColors.link),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(label: l10n.login, onPressed: _login, loading: loading),
              const SizedBox(height: 18),
              // Wrap(
              //   alignment: WrapAlignment.center,
              //   children: [
              //     Text(l10n.noAccount),
              //     TextButton(
              //       onPressed: () => context.push('/register'),
              //       child: Text(l10n.register, style: const TextStyle(color: AppColors.link)),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              TranslateLanguageButton(isArabic: isArabic, onPressed: _toggleLanguage),
            ],
          ),
        ),
      ),
    );
  }
}
