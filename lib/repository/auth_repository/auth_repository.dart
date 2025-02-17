import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/user/auth_user.dart';
import '../../util/json_converters/union_timestamp.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final authInstance = ref.watch(authInstanceProvider);
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  return AuthRepository(
    authInstance: authInstance,
    fireStoreInstance: fireStoreInstance
  );
}

final class AuthRepository {
  AuthRepository({
    required FirebaseAuth authInstance,
    required FirebaseFirestore fireStoreInstance,
  })  : _authInstance = authInstance,
        _fireStoreInstance = fireStoreInstance;

  final FirebaseAuth _authInstance;
  final FirebaseFirestore _fireStoreInstance;

  User? get currentUser => _authInstance.currentUser;

  Stream<User?> authStateChanges() => _authInstance.authStateChanges();

  Future<AuthUser?> signInAnonymously() async {
    final userCredential = await _authInstance.signInAnonymously();
    User? user = userCredential.user;
    if (user == null) {
      return null;
    }
    final authUser = AuthUser(
      id: user.uid,
      type: 0,
      createdAt: const UnionTimestamp.serverTimestamp(),
    );
    await _fireStoreInstance
        .collection('Users')
        .withConverter(
          fromFirestore: (ds, _) => AuthUser.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .doc(authUser.id)
        .set(authUser, SetOptions(merge: true));
    return authUser;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _authInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthUser?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await _authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user == null) {
      return null;
    }
    final authUser = AuthUser(
      id: user.uid,
      type: 1,
      name: name,
      email: email,
      createdAt: const UnionTimestamp.serverTimestamp(),
    );
    await _fireStoreInstance
        .collection('Users')
        .withConverter(
          fromFirestore: (ds, _) => AuthUser.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .doc(authUser.id)
        .set(authUser, SetOptions(merge: true));
    return authUser;
  }

  Future<AuthUser?> linkWithCredential({
    required String name,
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    final userCredential = await _authInstance.currentUser!.linkWithCredential(credential);
    User? user = userCredential.user;
    if (user == null) {
      return null;
    }
    final authUser = AuthUser(
      id: user.uid,
      type: 1,
      name: name,
      email: email,
      createdAt: const UnionTimestamp.serverTimestamp(),
    );
    await _fireStoreInstance
        .collection('Users')
        .withConverter(
      fromFirestore: (ds, _) => AuthUser.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => obj.toJson(),
    )
        .doc(authUser.id)
        .set(authUser, SetOptions(merge: true));
    return authUser;
  }

  Future<void> signOut() async {
    await _authInstance.signOut();
  }

  Future<void> delete({
    required String id
  }) async {
    await _authInstance.currentUser!.delete();
    _fireStoreInstance
        .collection('Users')
        .doc(id)
        .delete();
  }

}
