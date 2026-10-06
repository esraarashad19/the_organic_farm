import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/session/session.dart';
import '../../core/widgets/app_widgets.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  final landController = TextEditingController();
  List<FinancialData> items = [];
  FinancialData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).financials();
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

  void _openPdf(String? url, String fallbackError) {
    if (url == null || url.isEmpty) {
      showAppMessage(context, fallbackError, error: true);
      return;
    }
    context.push('/pdf?url=${Uri.encodeQueryComponent(url)}');
  }



  @override
  void dispose() {
    landController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = selected?.records ?? [];
    final name = ref.watch(sessionProvider).user?.displayName ?? '';
    return FarmScaffold(
      title: l10n.withUser(l10n.financials, name),
      child: LoadingOverlay(
        visible: loading,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            FarmCard(
              child: Column(
                children: [
                  AppField(
                    label: l10n.landNumber,
                    controller: landController,
                    readOnly: true,
                    onTap: _pick,
                    suffix: const Icon(Icons.arrow_drop_down),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: ()=>_openPdf(
                      selected?.fileUrl,
                      'Invalid partnership contract URL.',
                    ),
                    child: Column(
                      children: [
                        const FarmAsset(AppAssets.pdf, width: 72, height: 72),
                        const SizedBox(height: 8),
                        Text(l10n.accounts, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...records.map(
                    (record) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        '${record.month}  ${record.date}  ${record.amount}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
