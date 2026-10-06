import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network/api_client.dart';
import 'network/repositories.dart';
import 'session/session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider), ref.read(sessionProvider.notifier));
});

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  return FarmRepository(ref.watch(apiClientProvider));
});
