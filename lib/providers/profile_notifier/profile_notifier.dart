import 'package:asahiyama_go/model/user/auth_user.dart';
import 'package:asahiyama_go/repository/profile_repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth_notifier/auth_notifier.dart';

part 'profile_notifier.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<AuthUser?> build() {
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
    return profileRepository.userInfo();
  }

}
