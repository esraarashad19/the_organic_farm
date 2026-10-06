import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/session/session.dart';
import '../../core/widgets/app_widgets.dart';

class OperationsScreen extends ConsumerStatefulWidget {
  const OperationsScreen({super.key});

  @override
  ConsumerState<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends ConsumerState<OperationsScreen> {
  final landController = TextEditingController();
  List<OperationData> items = [];
  OperationData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).operations();
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
    final op = selected;
    final name = ref.watch(sessionProvider).user?.displayName ?? '';
    return FarmScaffold(
      title: l10n.withUser(l10n.technicalOperationsTitle, name),
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
                  if (op != null && op.pastOperations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _section(l10n.pastOperations, op.pastText),
                  ],
                  if (op != null && op.currentOperations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _section(l10n.currentOperations, op.currentText),
                  ],
                  if (op != null && op.futureOperations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _section(l10n.futureOperations, op.futureText),
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
