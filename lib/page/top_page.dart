import 'package:asahiyama_go/providers/like_notifier/like_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/profile/profile.dart';
import '../providers/post_notifier/post_notifier.dart';
import '../providers/profile_notifier/profile_notifier.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final profileNotifier = ref.watch(profileNotifierProvider);
    final posts = ref.watch(fetchPostProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              _userName(profileNotifier.value)
            ),
          ),
          SliverToBoxAdapter(
            child: posts.when(
                data: (data) {
                  return Column(
                    children: List.generate(data.length, (index) => Column(
                      children: [
                        Image.network(data[index].postImageUrl),
                        Text('${data[index].likeCount}'),
                        IconButton(
                            onPressed: () async {

                              final result = await ref.read(likeNotifierProvider.notifier).check(postsId: data[index].postId!);
                              if (result) return;

                              ref.read(likeNotifierProvider.notifier).increment(
                                  name: '',
                                  postsId: data[index].postId!,
                                  postImageUrl: data[index].postImageUrl,
                                  targetUserId: 'a',
                                  pushToken: '',
                                  category: 'cat',
                                  notificationId: 'a'
                              );
                            },
                            icon: const Icon(Icons.add)
                        ),
                      ],
                    )),
                  );
                },
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text("エラー: $error"),
            ),
          )
        ],
      ),
    );
  }

  String _userName(Profile? authUser) {
    if (authUser == null) {
      return '';
    }
    if (authUser.name == null || authUser.name == '') {
      return '未登録ユーザー';
    }
    return authUser.name!;
  }

}
