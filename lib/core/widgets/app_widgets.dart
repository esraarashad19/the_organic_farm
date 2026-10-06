import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_assets.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class FarmAsset extends StatelessWidget {
  const FarmAsset(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  Widget _fallback() {
    return Icon(
      Icons.eco_outlined,
      color: color ?? AppColors.primary,
      size: width ?? height ?? 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        placeholderBuilder: (_) => _fallback(),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height = 56});

  final double height;

  @override
  Widget build(BuildContext context) {
    return FarmAsset(AppAssets.logo, height: height, fit: BoxFit.contain);
  }
}

class FarmScaffold extends StatelessWidget {
  const FarmScaffold({
    super.key,
    required this.child,
    this.title,
    this.showClose = true,
    this.onClose,
    this.authBackground = false,
    this.showBrandHeader,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final bool showClose;
  final VoidCallback? onClose;
  final bool authBackground;
  final bool? showBrandHeader;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final brandHeader = showBrandHeader ?? !authBackground;
    final showHeader = brandHeader || showClose || title != null || trailing != null;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FarmAsset(AppAssets.background, fit: BoxFit.cover),
          const ColoredBox(color: AppColors.wash),
          SafeArea(
            child: Column(
              children: [
                if (showHeader)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          if (showClose)
                            IconButton(
                              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                              icon: const FarmAsset(AppAssets.close, width: 22, height: 22, color: AppColors.muted),
                            )
                          else
                            const SizedBox(width: 8),
                          if (brandHeader)
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: BrandLogo(height: 42),
                              ),
                            )
                          else
                            Expanded(
                              child: title == null
                                  ? const SizedBox.shrink()
                                  : Text(
                                      title!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.title,
                                      ),
                                    ),
                            ),
                          if (brandHeader) ...[
                            IconButton(
                              onPressed: () => showAppMessage(context, l10n.noNotifications),
                              icon: const FarmAsset(AppAssets.notifications, width: 28, height: 28),
                            ),
                            trailing ??
                                IconButton(
                                  onPressed: () => context.push('/settings'),
                                  icon: const FarmAsset(AppAssets.settings, width: 28, height: 28),
                                ),
                          ] else
                            trailing ?? const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                if (brandHeader && title != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.title,
                      ),
                    ),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FarmCard extends StatelessWidget {
  const FarmCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: color == null
          ? null
          : ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(label),
    );
  }
}

class TranslateLanguageButton extends StatelessWidget {
  const TranslateLanguageButton({super.key, required this.isArabic, required this.onPressed});

  final bool isArabic;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(isArabic ? l10n.translateToEnglish : l10n.translateToArabic),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.title),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (visible)
          const ColoredBox(
            color: AppColors.overlay,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.title),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: const TextStyle(fontSize: 16, color: AppColors.text)),
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: AppColors.iconHalo,
              shape: BoxShape.circle,
            ),
            child: Center(child: FarmAsset(icon, width: 54, height: 54)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.title),
          ),
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: FarmAsset(icon, width: 28, height: 28, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontSize: 18, color: AppColors.title)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

void showAppMessage(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.error : AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<T?> showLandPicker<T>({
  required BuildContext context,
  required List<T> items,
  required String Function(T item) label,
  T? selected,
}) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.landNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final selectedItem = selected == item;
                  return ListTile(
                    title: Text(label(item)),
                    trailing: selectedItem ? const Icon(Icons.check, color: AppColors.primary) : null,
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
