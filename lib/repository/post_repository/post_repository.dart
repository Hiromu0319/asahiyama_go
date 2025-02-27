import 'dart:typed_data';

import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart';

import '../../model/post/post.dart';
import '../../util/json_converters/union_timestamp.dart';

part 'post_repository.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(Ref ref) {
  final authInstance = ref.watch(authInstanceProvider);
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  final fireStorageInstance = ref.watch(fireStorageInstanceProvider);
  return PostRepository(
    authInstance: authInstance,
    fireStoreInstance: fireStoreInstance,
    fireStorageInstance: fireStorageInstance,
  );
}

final class PostRepository {
  PostRepository({
    required FirebaseAuth authInstance,
    required FirebaseFirestore fireStoreInstance,
    required FirebaseStorage fireStorageInstance,
  }) : _authInstance = authInstance,
        _fireStoreInstance = fireStoreInstance,
        _fireStorageInstance = fireStorageInstance;

  final FirebaseAuth _authInstance;
  final FirebaseFirestore _fireStoreInstance;
  final FirebaseStorage _fireStorageInstance;

  Future<void> upload({
    required String category,
    required String name,
    required String imagePath,
    required String pushToken,
    String? message,
    required Uint8List resizedUint8List,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }
    final storageRef = _fireStorageInstance.ref();
    final imageRef = storageRef.child('img/${basename(imagePath)}');
    final uploadTask = imageRef.putData(
      resizedUint8List,
      SettableMetadata(
        contentType: 'application/octet-stream',
      ),
    );
    final url = await (await uploadTask).ref.getDownloadURL();
    final post = Post(
      userId: user.uid,
      name: name,
      imagePath: 'img/${basename(imagePath)}',
      postImageUrl: url,
      pushToken: pushToken,
      category: category,
      message: message,
      createdAt: const UnionTimestamp.serverTimestamp(),
    );

    final addRef = await _fireStoreInstance
        .collection('Posts')
        .withConverter(
          fromFirestore: (ds, _) => Post.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .add(post);

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('posts')
        .doc(addRef.id)
        .withConverter(
          fromFirestore: (ds, _) => Post.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
       .set(post);

    await  _fireStoreInstance
        .collection(category)
        .doc(addRef.id)
        .withConverter(
          fromFirestore: (ds, _) => Post.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .set(post);

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .update({
          'postCount': FieldValue.increment(1),
        });

  }

  Future<void> delete({
    required String postsId,
    required String category,
    required String imagePath,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }
    await _fireStorageInstance
        .ref('img/${basename(imagePath)}')
        .delete();

    await _fireStoreInstance
        .collection('Posts')
        .doc(postsId)
        .delete();

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('posts')
        .doc(postsId)
        .delete();

    await  _fireStoreInstance
        .collection(category)
        .doc(postsId)
        .delete();

    await  _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .update({
          'postCount': FieldValue.increment(-1),
        });

  }

  Future<Post?> postInformation({
    required String id,
  }) async {

    final postSnapshot = await _fireStoreInstance
        .collection('Posts')
        .doc(id)
        .withConverter(
          fromFirestore: (ds, _) => Post.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        )
        .get();

    return postSnapshot.data();
  }

  Stream<List<Post>> fetch() {
    final collection = _fireStoreInstance.collection('Posts');
    final stream = collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((e) => e.docs.map((e) => Post.fromJsonAddPostId(e.data(), e.id)).toList());
    return stream;
  }

  Stream<List<Post>> fetchCategory({
    required String category
  }) {
    final collection = _fireStoreInstance.collection(category);
    final stream = collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((e) => e.docs.map((e) => Post.fromJsonAddPostId(e.data(), e.id)).toList());
    return stream;
  }

}
