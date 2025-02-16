import 'package:asahiyama_go/providers/profile_notifier/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/user/auth_user.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final profileNotifier = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
                _userName(profileNotifier.value)
            ),
          ),
        ],
      ),
    );
  }

  String _userName(AuthUser? authUser) {
    if (authUser == null) {
      return '';
    }
    if (authUser.name == null || authUser.name == '') {
      return '未登録ユーザー';
    }
    return authUser.name!;
  }

}
