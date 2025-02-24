import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repository/like_repository/like_repository.dart';

part 'like_notifier.g.dart';

@Riverpod(keepAlive: true)
class LikeNotifier extends _$LikeNotifier {
  @override
  LikeState build() => LikeState.notPress;

  Future<void> increment({
    required String name,
    required String postsId,
    required String postImageUrl,
    required String targetUserId,
    required String pushToken,
    required String category,
    required String notificationId
  }) async {
    state = LikeState.loading;

    final likeRepository = ref.read(likeRepositoryProvider);
    await likeRepository.increment(
        name: name,
        postsId: postsId,
        postImageUrl: postImageUrl,
        targetUserId: targetUserId,
        pushToken: pushToken,
        category: category,
        notificationId: notificationId
    );

    state = LikeState.notPress;
  }

  Future<void> decrement({
    required String likesId,
    required String postsId,
    required String category,
  }) async {
    state = LikeState.loading;

    final likeRepository = ref.read(likeRepositoryProvider);
    await likeRepository.decrement(
        likesId: likesId,
        postsId: postsId,
        category: category,
    );

    state = LikeState.notPress;
  }

  Future<bool> check({
    required String postsId,
  }) async {
    final likeRepository = ref.read(likeRepositoryProvider);
    return likeRepository.check(postsId: postsId);
  }

}

enum LikeState {
  loading,
  notPress
}