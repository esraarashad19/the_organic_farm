import 'package:cached_network_image/cached_network_image.dart';
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

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  final landController = TextEditingController();
  List<MediaData> items = [];
  MediaData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).media();
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
    final images = selected?.images ?? [];
    final videos = selected?.videos ?? [];
    final name = ref.watch(sessionProvider).user?.displayName ?? '';

    return FarmScaffold(
      title: l10n.withUser(l10n.imagesVideos, name),
      child: LoadingOverlay(
        visible: loading,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const SizedBox(height: 16),
                  Text(l10n.images, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final url = images[index].filePath ?? '';
                        return GestureDetector(
                          onTap: () => context.push('/image?url=${Uri.encodeQueryComponent(url)}'),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const FarmAsset(AppAssets.noImage, fit: BoxFit.cover),
                              errorWidget: (_, __, ___) => const FarmAsset(AppAssets.noImage, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.videos, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: videos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => context.push('/video?url=${Uri.encodeQueryComponent(videos[index].filePath ?? '')}'),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                FarmAsset(AppAssets.videoPlaceholder, width: 140, height: 120, fit: BoxFit.cover),
                                Icon(Icons.play_circle_fill, color: Colors.white, size: 42),
                              ],
                            ),
                          ),
                        );
                      },
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
