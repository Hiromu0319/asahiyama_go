import 'package:asahiyama_go/repository/profile_repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/profile/profile.dart';
import '../auth_notifier/auth_notifier.dart';

part 'profile_notifier.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<Profile?> build() {
    ref.listen(
      authNotifierProvider,
          (_, next) {
        if (next == null) {
          state = const AsyncData(null);
        } else {
          ref.invalidateSelf();
        }
      },
    );
    final profileRepository = ref.watch(profileRepositoryProvider);
    return profileRepository.fetchProfile();
  }

  Future<void> deletePost({
    required String category,
    required String id,
    required String imagePath
  }) async {
    final profileRepository = ref.watch(profileRepositoryProvider);
    await profileRepository.deletePost(category: category, id: id, imagePath: imagePath);
    ref.invalidateSelf();
  }

}

@riverpod
Future<List<Post?>> fetchMyPost(ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return profileRepository.fetchPosts();
}

@riverpod
Future<List<Like?>> fetchMyLike(ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return profileRepository.fetchLikes();
}