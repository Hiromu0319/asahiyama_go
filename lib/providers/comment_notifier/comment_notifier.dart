import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repository/comment_repository/comment_repository.dart';

part 'comment_notifier.g.dart';

@Riverpod(keepAlive: true)
class CommentNotifier extends _$CommentNotifier {
  @override
  CommentState build() => CommentState.notPress;

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
    state = CommentState.loading;

    final commentRepository = ref.read(commentRepositoryProvider);
    await commentRepository.post(
        name: name,
        category: category,
        postsId: postsId,
        postImageUrl: postImageUrl,
        targetUserId: targetUserId,
        pushToken: pushToken,
        notificationId: notificationId,
        message: message
    );

    state = CommentState.notPress;
  }

  Future<void> delete({
    required String commentsId,
    required String postsId,
    required String category,
  }) async {
    state = CommentState.loading;

    final commentRepository = ref.read(commentRepositoryProvider);
    await commentRepository.delete(
        commentsId: commentsId,
        postsId: postsId,
        category: category
    );

    state = CommentState.notPress;
  }

}

enum CommentState {
  loading,
  notPress
}