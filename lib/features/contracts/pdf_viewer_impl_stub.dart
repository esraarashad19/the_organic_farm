import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/widgets/app_widgets.dart';

class PdfViewerScreen extends StatelessWidget {
  final bool withTitle;
  const PdfViewerScreen({super.key, required this.url,this.withTitle=true});

  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (url.isEmpty) {
      return FarmScaffold(
        title: withTitle?l10n.contractTitle:null,
        child: const Center(child: Text('Invalid file URL.')),
      );
    }

    return FarmScaffold(
      //title: withTitle?l10n.contractTitle:null,
      child: Center(
        child: FilledButton(
          onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          child: const Text('Open PDF'),
        ),
      ),
    );
  }
}
