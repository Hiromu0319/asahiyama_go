import 'package:asahiyama_go/model/like/like.dart';
import 'package:asahiyama_go/model/profile/profile.dart' as pro;
import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../util/json_converters/union_timestamp.dart';

part 'like_repository.g.dart';

@Riverpod(keepAlive: true)
LikeRepository likeRepository(Ref ref) {
  final authInstance = ref.watch(authInstanceProvider);
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  return LikeRepository(
    authInstance: authInstance,
    fireStoreInstance: fireStoreInstance,
  );
}

final class LikeRepository {
  LikeRepository({
    required FirebaseAuth authInstance,
    required FirebaseFirestore fireStoreInstance,
  }) : _authInstance = authInstance,
        _fireStoreInstance = fireStoreInstance;

  final FirebaseAuth _authInstance;
  final FirebaseFirestore _fireStoreInstance;

  Future<void> increment({
    required String name,
    required String postsId,
    required String postImageUrl,
    required String targetUserId,
    required String pushToken,
    required String category,
    required String notificationId
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }
    final like = Like(
        userId: user.uid,
        name: name,
        postsId: postsId,
        postImageUrl: postImageUrl,
        targetUserId: targetUserId,
        pushToken: pushToken,
        category: category,
        createdAt: const UnionTimestamp.serverTimestamp(),
    );

    final likeRef = await _fireStoreInstance
        .collection('Likes')
        .withConverter(
          fromFirestore: (ds, _) => Like.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .add(like);

    final proLike = pro.Like(
      postsId: postsId,
      likesId: likeRef.id,
      notificationsId: notificationId,
      postImageUrl: postImageUrl,
      category: category,
      createdAt: const UnionTimestamp.serverTimestamp(),
    );

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('likes')
        .doc(postsId)
        .withConverter(
          fromFirestore: (ds, _) => pro.Like.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .set(proLike);

    await  _fireStoreInstance
        .collection('Posts')
        .doc(postsId)
        .update({
          'likeCount': FieldValue.increment(1),
        });

    await  _fireStoreInstance
        .collection(category)
        .doc(postsId)
        .update({
          'likeCount': FieldValue.increment(1),
        });

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .update({
         'likeCount': FieldValue.increment(1),
        });
  }

  Future<void> decrement({
    required String likesId,
    required String postsId,
    required String category,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }

    await _fireStoreInstance
        .collection('Likes')
        .doc(likesId)
        .delete();

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('likes')
        .doc(postsId)
        .delete();

    await  _fireStoreInstance
        .collection('Posts')
        .doc(postsId)
        .update({
      'likeCount': FieldValue.increment(-1),
    });

    await  _fireStoreInstance
        .collection(category)
        .doc(postsId)
        .update({
      'likeCount': FieldValue.increment(-1),
    });

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .update({
      'likeCount': FieldValue.increment(-1),
    });
  }

  Future<bool> check({
    required String postsId,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return false;
    }
    final docSnapshot =  await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('likes')
        .doc(postsId)
        .get();

    return docSnapshot.exists;
  }

}
