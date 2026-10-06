import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> openExcelFile(String url) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/Financials.xlsx');
  await Dio().download(url, file.path);
  final result = await OpenFilex.open(file.path);
  if (result.type != ResultType.done) {
    await Share.shareXFiles([XFile(file.path)], text: 'Financials.xlsx');
  }
}
