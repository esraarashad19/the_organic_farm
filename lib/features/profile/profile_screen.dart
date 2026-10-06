import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/widgets/app_widgets.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await ref.read(authRepositoryProvider).getProfile();
      nameController.text = user.fullName ?? user.name ?? '';
      idController.text = user.idNumber ?? '';
      phoneController.text = user.phoneNumber ?? '';
      emailController.text = user.email ?? '';
    } on ApiException catch (e) {
      if (mounted) showAppMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      final message = await ref.read(authRepositoryProvider).updateProfile(
            fullName: nameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            idNumber: idController.text.trim(),
            password: passwordController.text,
          );
      if (!mounted) return;
      showAppMessage(context, message);
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FarmScaffold(
      title: l10n.profileTitle,
      child: LoadingOverlay(
        visible: loading || saving,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: FarmCard(
            child: Column(
              children: [
                AppField(label: l10n.fullNameLabel, controller: nameController, hint: l10n.fullNamePlaceholder),
                const SizedBox(height: 10),
                AppField(label: l10n.nationalIdLabel, controller: idController, hint: l10n.nationalIdPlaceholder),
                const SizedBox(height: 10),
                AppField(
                  label: l10n.phoneNumberLabel,
                  controller: phoneController,
                  hint: l10n.phonePlaceholder,
                  keyboardType: TextInputType.phone,
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
                  label: l10n.passwordLabel,
                  controller: passwordController,
                  hint: l10n.passwordPlaceholder,
                  obscure: true,
                ),
                const SizedBox(height: 24),
                PrimaryButton(label: l10n.save, onPressed: _save, loading: saving),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
