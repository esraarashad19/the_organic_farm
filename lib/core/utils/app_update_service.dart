import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../app_router.dart';

class AppUpdateService {
  static Future<void> checkForUpdate() async {
    try {
      final newVersion = NewVersionPlus(
        androidId: 'YOUR_ANDROID_PACKAGE_NAME',
        iOSId: 'YOUR_IOS_BUNDLE_ID',
        iOSAppStoreCountry: 'EG',
      );

      final status = await newVersion.getVersionStatus();

      debugPrint('Version status: ${status?.toString()}');

      final context = rootNavigatorKey.currentContext;

      if (context == null) {
        debugPrint('Navigator context is not available.');
        return;
      }





      if (status == null || !status.canUpdate) {
        debugPrint('No update available.');
        return;
      }

      debugPrint('Current version: ${status.localVersion}');
      debugPrint('Store version: ${status.storeVersion}');
      debugPrint('Update URL: ${status.appStoreLink}');



       newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available',
        dialogText:
        'A new version of the app is available. '
            'Please update to the latest version.',
        updateButtonText: 'Update',
        dismissButtonText: 'Later',
        allowDismissal: true,
      );
    } catch (e) {
      debugPrint('Version check error: $e');
    }
  }
}