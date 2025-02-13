import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/app_version/app_version.dart';
import '../../repository/app_version_repository/app_version_repository.dart';

part 'app_version_provider.g.dart';

@riverpod
Future<AppVersion?> getAppVersion(
    Ref ref, {
      required String platform,
    }) async {
  final repository = ref.watch(appVersionRepositoryProvider);
  return repository.getAppVersion(platform: platform);
}