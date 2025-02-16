import 'package:asahiyama_go/repository/auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_changes.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  final authUser = ref.watch(authRepositoryProvider).authStateChanges();
  return authUser;
}
