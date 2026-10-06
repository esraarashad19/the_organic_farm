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

class ContractsScreen extends ConsumerStatefulWidget {
  const ContractsScreen({super.key});

  @override
  ConsumerState<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends ConsumerState<ContractsScreen> {
  final landController = TextEditingController();
  List<ContractData> items = [];
  ContractData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).contracts();
      ContractData? details = data.isNotEmpty ? data.first : null;
      if (details != null) {
        details = await ref.read(farmRepositoryProvider).contractDetails(details.id) ?? details;
      }
      if (!mounted) return;
      setState(() {
        items = data;
        selected = details;
        landController.text = details?.land?.landNumber ?? '';
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
    if (picked == null) return;
    setState(() => loading = true);
    try {
      final details = await ref.read(farmRepositoryProvider).contractDetails(picked.id) ?? picked;
      if (!mounted) return;
      setState(() {
        selected = details;
        landController.text = details.land?.landNumber ?? '';
        loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showAppMessage(context, e.message, error: true);
    }
  }

  void _openPdf(String? url, String fallbackError,{bool withTitle=true}) {
    if (url == null || url.isEmpty) {
      showAppMessage(context, fallbackError, error: true);
      return;
    }
    context.push('/pdf?url=${Uri.encodeQueryComponent(url)}&withTitle=$withTitle');
  }

  void _openImage(String? url) {
    if (url == null || url.isEmpty) {
      showAppMessage(context, 'Personal ID image not available.', error: true);
      return;
    }
    context.push('/image?url=${Uri.encodeQueryComponent(url)}');
  }

  void _openFile(String? url) {
    if (url == null || url.isEmpty) {
      showAppMessage(
        context,
        'File not available.',
        error: true,
      );
      return;
    }

    final path = Uri.parse(url).path.toLowerCase();

    if (path.endsWith('.pdf')) {
      _openPdf(url,'Personal ID image not available.',withTitle: false);
    } else {

      _openImage(url);
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
    final name = ref.watch(sessionProvider).user?.displayName ?? '';
    return FarmScaffold(
      title: l10n.withUser(l10n.contractTitle, name),
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
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _doc(
                          AppAssets.pdf,
                          l10n.sponsorshipContract,
                          () => _openPdf(
                            selected?.documents?.sponsorshipContractUrl,
                            'Invalid sponsorship contract URL.',
                          ),
                        ),
                      ),
                      Expanded(
                        child: _doc(
                          AppAssets.pdf,
                          l10n.partnershipContract,
                          () => _openPdf(
                            selected?.documents?.participationContractUrl,
                            'Invalid partnership contract URL.',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _doc(AppAssets.memberCard, l10n.personalCard, () {
                    _openFile(selected?.documents?.personalIdUrl);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doc(String icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            FarmAsset(icon, width: 72, height: 72),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
