import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:asahiyama_go/model/profile/profile.dart' as pro;

import '../../model/comment/comment.dart';
import '../../util/json_converters/union_timestamp.dart';

part 'comment_repository.g.dart';

@Riverpod(keepAlive: true)
CommentRepository commentRepository(Ref ref) {
  final authInstance = ref.watch(authInstanceProvider);
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  return CommentRepository(
    authInstance: authInstance,
    fireStoreInstance: fireStoreInstance,
  );
}

final class CommentRepository {
  CommentRepository({
    required FirebaseAuth authInstance,
    required FirebaseFirestore fireStoreInstance,
  }) : _authInstance = authInstance,
        _fireStoreInstance = fireStoreInstance;

  final FirebaseAuth _authInstance;
  final FirebaseFirestore _fireStoreInstance;

  Future<void> post({
    required String name,
    required String category,
    required String postsId,
    required String postImageUrl,
    required String targetUserId,
    required String pushToken,
    required String notificationId,
    required String message,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }

    final comment = Comment(
      userId: user.uid,
      name: name,
      postsId: postsId,
      postImageUrl: postImageUrl,
      targetUserId: targetUserId,
      pushToken: pushToken,
      message: message,
      createdAt: const UnionTimestamp.serverTimestamp(),
    );

    final commentRef = await _fireStoreInstance
        .collection('Comments')
        .withConverter(
          fromFirestore: (ds, _) => Comment.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .add(comment);

    final proComment = pro.Comment(
        commentsId: commentRef.id,
        postsId: postsId,
        notificationsId: notificationId,
        category: category,
        message: message,
        createdAt: const UnionTimestamp.serverTimestamp(),
    );

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('comments')
        .doc(commentRef.id)
        .withConverter(
          fromFirestore: (ds, _) => pro.Comment.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .set(proComment);

    await  _fireStoreInstance
        .collection('Posts')
        .doc(postsId)
        .update({
          'commentCount': FieldValue.increment(1),
          'comments' : FieldValue.arrayUnion([commentRef.id]),
        });

    await  _fireStoreInstance
        .collection(category)
        .doc(postsId)
        .update({
         'commentCount': FieldValue.increment(1),
         'comments' : FieldValue.arrayUnion([commentRef.id]),
        });

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .update({
         'commentCount': FieldValue.increment(1),
    });
  }

  Future<void> delete({
    required String commentsId,
    required String postsId,
    required String category,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }

    await _fireStoreInstance
        .collection('Comments')
        .doc(commentsId)
        .delete();

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('comments')
        .doc(commentsId)
        .delete();

    await  _fireStoreInstance
        .collection('Posts')
        .doc(postsId)
        .update({
         'commentCount': FieldValue.increment(-1),
         'comments': FieldValue.arrayRemove([commentsId]),
        });

    await  _fireStoreInstance
        .collection(category)
        .doc(postsId)
        .update({
         'commentCount': FieldValue.increment(-1),
         'comments': FieldValue.arrayRemove([commentsId]),
        });

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .update({
         'commentCount': FieldValue.increment(-1),
        });
  }


}
