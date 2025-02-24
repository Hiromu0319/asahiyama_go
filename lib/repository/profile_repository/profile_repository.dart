import 'package:asahiyama_go/providers/firebase_client/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/profile/profile.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  final authInstance = ref.watch(authInstanceProvider);
  final fireStoreInstance = ref.watch(fireStoreInstanceProvider);
  final fireStorageInstance = ref.watch(fireStorageInstanceProvider);
  return ProfileRepository(
    authInstance: authInstance,
    fireStoreInstance: fireStoreInstance,
    fireStorageInstance: fireStorageInstance
  );
}

final class ProfileRepository {
  ProfileRepository({
    required FirebaseAuth authInstance,
    required FirebaseFirestore fireStoreInstance,
    required FirebaseStorage fireStorageInstance,
  }) : _authInstance = authInstance,
        _fireStoreInstance = fireStoreInstance,
        _fireStorageInstance = fireStorageInstance;

  final FirebaseAuth _authInstance;
  final FirebaseFirestore _fireStoreInstance;
  final FirebaseStorage _fireStorageInstance;

  Future<Profile?> fetchProfile() async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return null;
    }
    final profileSnapshot = await _fireStoreInstance
        .collection('Users')
        .withConverter(
          fromFirestore: (ds, _) => Profile.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson()
         )
        .doc(user.uid)
        .get();
    return profileSnapshot.data();
  }

  Future<List<Post?>> fetchPosts() async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return [];
    }
    final postsSnapshot = await _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('posts')
        .get();
    final posts = postsSnapshot.docs.map((doc) => Post.fromDocumentSnapshot(doc)).toList();
    return posts;
  }

  Future<void> deletePost({
    required String category,
    required String id,
    required String imagePath,
  }) async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return;
    }
    final imageRef = _fireStorageInstance.ref('img/${basename(imagePath)}');
    imageRef.delete();

    await _fireStoreInstance
      .collection('Posts')
      .doc(id)
      .delete();

    await _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('posts')
        .doc(id)
        .delete();

    await _fireStoreInstance
        .collection(category)
        .doc(id)
        .delete();

  }

  Future<List<Like?>> fetchLikes() async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return [];
    }
    final likesSnapshot = await _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('likes')
        .get();
    final likes = likesSnapshot.docs.map((doc) => Like.fromDocumentSnapshot(doc)).toList();
    return likes;
  }

  Future<List<Comment?>> fetchComments() async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return [];
    }
    final commentsSnapshot = await _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('comments')
        .get();
    final comments = commentsSnapshot.docs.map((doc) => Comment.fromDocumentSnapshot(doc)).toList();
    return comments;
  }

  Future<List<Notification?>> fetchNotifications() async {
    User? user = _authInstance.currentUser;
    if (user == null) {
      return [];
    }
    final notificationsSnapshot = await _fireStoreInstance
        .collection('Users')
        .doc(user.uid)
        .collection('notifications')
        .get();
    final notifications = notificationsSnapshot.docs.map((doc) => Notification.fromDocumentSnapshot(doc)).toList();
    return notifications;
  }

}
