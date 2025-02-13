import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/app_version/app_version.dart';

part 'app_version_repository.g.dart';

@Riverpod(keepAlive: true)
AppVersionRepository appVersionRepository(Ref ref) {
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  return AppVersionRepository(
    fireStoreInstance: fireStoreInstance,
  );
}

final class AppVersionRepository {
  AppVersionRepository({
    required FirebaseFirestore fireStoreInstance,
  }) : _fireStoreInstance = fireStoreInstance;

  final FirebaseFirestore _fireStoreInstance;

  Future<AppVersion?> getAppVersion({
    required String platform,
  }) async {
    final result = await _fireStoreInstance
        .collection('app_version')
        .doc(platform)
        .get();
    final data = result.data();
    if (data == null) {
      return null;
    }
    return AppVersion.fromJson(data);
  }

}
