import 'excel_opener_stub.dart'
    if (dart.library.io) 'excel_opener_io.dart' as impl;

Future<void> openExcelFile(String url) => impl.openExcelFile(url);
