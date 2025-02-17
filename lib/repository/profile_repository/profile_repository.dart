import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/user/auth_user.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  final authInstance = ref.watch(authInstanceProvider);
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  return ProfileRepository(
    authInstance: authInstance,
    fireStoreInstance: fireStoreInstance,
  );
}

final class ProfileRepository {
  ProfileRepository({
    required FirebaseAuth authInstance,
    required FirebaseFirestore fireStoreInstance,
  }) : _authInstance = authInstance,
        _fireStoreInstance = fireStoreInstance;

  final FirebaseAuth _authInstance;
  final FirebaseFirestore _fireStoreInstance;

  Future<AuthUser?> userInfo() async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return null;
    }
    final userInfoSnapshot = await _fireStoreInstance
        .collection('Users')
        .withConverter(
          fromFirestore: (ds, _) => AuthUser.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson()
         )
        .doc(user.uid)
        .get();
    return userInfoSnapshot.data();
  }

}
