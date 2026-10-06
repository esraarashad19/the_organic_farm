import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/session/session.dart';
import '../../core/widgets/app_widgets.dart';

class LandScreen extends ConsumerStatefulWidget {
  const LandScreen({super.key});

  @override
  ConsumerState<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends ConsumerState<LandScreen> {
  final landController = TextEditingController();
  List<LandData> lands = [];
  LandData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await ref.read(farmRepositoryProvider).lands();
      if (items.isNotEmpty) {
        await _select(items.first, replaceList: items);
      } else {
        setState(() {
          lands = items;
          loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => loading = false);
        showAppMessage(context, e.message, error: true);
      }
    }
  }

  Future<void> _select(LandData land, {List<LandData>? replaceList}) async {
    setState(() {
      if (replaceList != null) lands = replaceList;
      selected = land;
      landController.text = land.landNumber ?? '';
      loading = true;
    });
    try {
      final details = await ref.read(farmRepositoryProvider).landDetails(land.id ?? 0);
      if (!mounted) return;
      setState(() {
        selected = details ?? land;
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
      items: lands,
      label: (item) => item.landNumber ?? '',
      selected: selected,
    );
    if (picked != null) await _select(picked);
  }

  @override
  void dispose() {
    landController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final details = selected;
    final name = ref.watch(sessionProvider).user?.displayName ?? '';
    return FarmScaffold(
      title: l10n.withUser(l10n.landData, name),
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
                  InfoRow(label: l10n.landSize, value: details?.size ?? l10n.na),
                  InfoRow(label: l10n.numberOfPits, value: '${details?.numberOfPits ?? 0}'),
                  InfoRow(label: l10n.numberOfPalms, value: '${details?.numberOfPalms ?? 0}'),
                  InfoRow(label: l10n.cultivationCount, value: details?.cultivationCount ?? l10n.na),
                  InfoRow(label: l10n.missingCount, value: details?.missingCount ?? l10n.na),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
