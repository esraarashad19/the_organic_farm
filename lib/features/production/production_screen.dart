import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/session/session.dart';
import '../../core/widgets/app_widgets.dart';

class ProductionScreen extends ConsumerStatefulWidget {
  const ProductionScreen({super.key});

  @override
  ConsumerState<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends ConsumerState<ProductionScreen> {
  final landController = TextEditingController();
  List<ProductionData> items = [];
  ProductionData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).productions();
      setState(() {
        items = data;
        selected = data.isNotEmpty ? data.first : null;
        landController.text = selected?.land?.landNumber ?? '';
        loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showAppMessage(context, e.message, error: true);
    }
  }

  Future<void> _pick() async {
    final picked = await showLandPicker(
      context: context,
      items: items,
      label: (item) => item.land?.landNumber ?? '',
      selected: selected,
    );
    if (picked != null) {
      setState(() {
        selected = picked;
        landController.text = picked.land?.landNumber ?? '';
      });
    }
  }

  @override
  void dispose() {
    landController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = selected;
    final name = ref.watch(sessionProvider).user?.displayName ?? '';
    return FarmScaffold(
      title: l10n.withUser(l10n.production, name),
      child: LoadingOverlay(
        visible: loading,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            FarmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppField(
                    label: l10n.landNumber,
                    controller: landController,
                    readOnly: true,
                    onTap: _pick,
                    suffix: const Icon(Icons.arrow_drop_down),
                  ),
                  if (item != null && item.pastProductions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _section(l10n.pastProduction, item.pastText),
                  ],
                  if (item != null && item.currentProductions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _section(l10n.currentProduction, item.currentText),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(body, style: const TextStyle(fontSize: 16, height: 1.4)),
      ],
    );
  }
}
