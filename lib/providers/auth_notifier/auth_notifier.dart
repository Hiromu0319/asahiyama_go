import 'package:asahiyama_go/model/user/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:asahiyama_go/repository/auth_repository/auth_repository.dart';
import '../auth_state_changes/auth_state_changes.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  User? build() {
    final authRepository = ref.watch(authRepositoryProvider);
    ref.listen(
      authStateChangesProvider,
          (_, __) => ref.invalidateSelf(),
    );
    final currentUser = authRepository.currentUser;
    return currentUser;
  }

  Future<AuthUser?> signInAnonymously() async {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.signInAnonymously();
  }

  Future<void> signIn({
    required String email,
    required String password
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signIn(email: email, password: password);
  }

  Future<AuthUser?> signUp({
    required String name,
    required String email,
    required String password
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.signUp(name: name, email: email, password: password);
  }

  Future<AuthUser?> linkWithCredential({
    required String name,
    required String email,
    required String password
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.linkWithCredential(name: name, email: email, password: password);
  }

  Future<void> signOut() async => ref.read(authRepositoryProvider).signOut();

  Future<void> delete({
    required String id,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.delete(id: id);
  }

}
