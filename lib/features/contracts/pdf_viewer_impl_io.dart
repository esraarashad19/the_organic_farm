import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/widgets/app_widgets.dart';

class PdfViewerScreen extends StatefulWidget {
  final bool withTitle;

  const PdfViewerScreen({super.key, required this.url,this.withTitle=true});

  final String url;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late final WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final encoded = Uri.encodeComponent(widget.url);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => loading = false),
          onWebResourceError: (_) => setState(() => loading = false),
        ),
      )
      ..loadRequest(Uri.parse('https://docs.google.com/gview?embedded=true&url=$encoded'));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.url.isEmpty) {
      return FarmScaffold(
        title:widget.withTitle? l10n.contractTitle:null,
        child: const Center(child: Text('Invalid file URL.')),
      );
    }

    return FarmScaffold(
      //title:widget.withTitle? l10n.contractTitle:null,
      child: LoadingOverlay(
        visible: loading,
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
