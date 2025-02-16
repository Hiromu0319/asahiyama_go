import 'package:asahiyama_go/routing/main_page_shell_route/main_page_shell_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_notifier/auth_notifier.dart';
import '../routing/routes.dart';
import '../ui_core/error_dialog.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: Column(
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
                try {
                  await ref.read(authNotifierProvider.notifier).signUp(
                      name: nameController.value.text,
                      email: emailController.value.text,
                      password: passwordController.value.text);
                  if (context.mounted) {
                    const TopPageRoute().go(context);
                  }
                } on FirebaseAuthException catch (_) {
                  if (context.mounted) {
                    ErrorDialog.show(
                        context: context, message: 'アカウントの作成に失敗しました。');
                  }
                }
              },
              child: const Text('登録')
          ),
        ],
      ),
    );
  }
}
