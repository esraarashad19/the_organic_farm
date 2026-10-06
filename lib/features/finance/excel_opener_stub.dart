import 'package:url_launcher/url_launcher.dart';

Future<void> openExcelFile(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not open $url');
  }
}
