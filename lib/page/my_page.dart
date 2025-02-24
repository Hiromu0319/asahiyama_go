import 'package:asahiyama_go/providers/auth_notifier/auth_notifier.dart';
import 'package:asahiyama_go/routing/main_page_shell_route/main_page_shell_route.dart';
import 'package:asahiyama_go/routing/routes.dart';
import 'package:asahiyama_go/ui_core/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/profile_notifier/profile_notifier.dart';

class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(profileNotifierProvider);
    final myPost = ref.watch(fetchMyPostProvider);

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'ユーザーネーム',
          ),
        ),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'メールアドレス',
          ),
        ),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'パスワード',
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              if (user.value != null && user.value?.type == 0) {
                try {
                  await ref.read(authNotifierProvider.notifier).linkWithCredential(
                      name: nameController.value.text,
                      email: emailController.value.text,
                      password: passwordController.value.text);
                } catch (e) {
                  if (context.mounted) {
                    ErrorDialog.show(
                        context: context,
                        message: 'アカウント化できません'
                    );
                  }
                }
              }
            },
            child: const Text('アカウント化')
        ),
        ElevatedButton(
            onPressed: () async {
              if (user.value != null) {
                if (user.value!.type != 0) {
                  try {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      const SignInPageRoute().push(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ErrorDialog.show(
                          context: context,
                          message: 'ログアウトできません'
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ErrorDialog.show(
                        context: context,
                        message: 'このユーザーはアカウントの削除が必要です。'
                    );
                  }
                }
              }
            },
            child: const Text('ログアウト')
        ),
        ElevatedButton(
            onPressed: () async {
              if (user.value != null) {
                try {
                  await ref.read(authNotifierProvider.notifier).delete(id: user.value!.id);
                  if (context.mounted) {
                    const SignInPageRoute().push(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ErrorDialog.show(
                        context: context,
                        message: 'アカウントの削除に失敗しました。'
                    );
                  }
                }
              }
            },
            child: const Text('アカウント削除')
        ),
        if (user.value != null && user.value?.type == 2)
          ElevatedButton(
              onPressed: () {},
              child: const Text('Push通知を送信する')
          ),
        myPost.when(
          data: (data) {
            return Column(
              children: List.generate(data.length, (index) => Column(
                children: [
                  Image.network(data[index]!.postImageUrl, height: 80),
                  IconButton(
                        onPressed: () {
                          ref.read(profileNotifierProvider.notifier)
                              .deletePost(
                              category: data[index]!.category,
                              id: data[index]!.postsId,
                              imagePath: data[index]!.imagePath
                          );
                        },
                        icon: const Icon(Icons.delete)
                    ),
                ],
              )),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text("エラー: $error"),
        )
      ],
    );
  }
}
