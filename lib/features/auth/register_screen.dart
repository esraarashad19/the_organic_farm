import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/session/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  String idType = 'national_id';
  bool loading = false;
  bool obscure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final error = Validators.registerError(
      fullName: nameController.text,
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      idNumber: idController.text,
      password: passwordController.text,
    );
    if (error != null) {
      showAppMessage(context, error, error: true);
      return;
    }

    setState(() => loading = true);
    try {
      await ref.read(authRepositoryProvider).register(
            fullName: nameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            idType: idType,
            idNumber: idController.text.trim(),
            password: passwordController.text,
          );
      if (!mounted) return;
      showAppMessage(context, l10n.loginSuccess);
      context.go('/dashboard');
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _idOption(String value, String label) {
    final selected = idType == value;
    return InkWell(
      onTap: () => setState(() => idType = value),
      child: Row(
        children: [
          FarmAsset(
            selected ? AppAssets.radioSelected : AppAssets.radioUnselected,
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(sessionProvider).isArabic;
    return FarmScaffold(
      authBackground: true,
      showClose: true,
      child: LoadingOverlay(
        visible: loading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              const BrandLogo(height: 72),
              const SizedBox(height: 12),
              Text(
                l10n.registerTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              AppField(
                label: l10n.fullNameLabel,
                controller: nameController,
                hint: l10n.fullNamePlaceholder,
              ),
              const SizedBox(height: 10),
              AppField(
                label: l10n.emailLabel,
                controller: emailController,
                hint: l10n.emailPlaceholder,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              AppField(
                label: l10n.phoneNumberLabel,
                controller: phoneController,
                hint: l10n.phonePlaceholder,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(l10n.idTypeLabel, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _idOption('national_id', l10n.nationalId)),
                  Expanded(child: _idOption('passport', l10n.passport)),
                ],
              ),
              const SizedBox(height: 10),
              AppField(
                label: l10n.nationalIdLabel,
                controller: idController,
                hint: l10n.t('id_number_placeholder'),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              PrimaryButton(label: l10n.registerButton, onPressed: _submit, loading: loading),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAccount),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.loginLink, style: const TextStyle(color: AppColors.link)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TranslateLanguageButton(
                isArabic: isArabic,
                onPressed: () {
                  ref.read(sessionProvider.notifier).setLanguage(
                        isArabic ? const Locale('en') : const Locale('ar'),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
