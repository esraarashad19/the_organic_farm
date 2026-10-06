import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/widgets/app_widgets.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _call(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        showAppMessage(context, 'Unable to make a call', error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FarmScaffold(
      title: l10n.contactTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: FarmCard(
          child: Column(
            children: [
              _row(context, l10n.contactAccounts, ContactPhones.accounts),
              _row(context, l10n.contactAgriculture, ContactPhones.agriculture),
              _row(context, l10n.contactCustomerService, ContactPhones.customerService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          IconButton(
            onPressed: () => _call(context, phone),
            icon: const FarmAsset(AppAssets.phoneCall, width: 32, height: 32),
          ),
        ],
      ),
    );
  }
}
