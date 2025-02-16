import 'package:asahiyama_go/providers/auth_notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../ui_core/error_dialog.dart';
import '../routing/routes.dart';
import '../routing/main_page_shell_route/main_page_shell_route.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                await ref.read(authNotifierProvider.notifier).signIn(
                    email: emailController.value.text,
                    password: passwordController.value.text);
                if (context.mounted) {
                  const TopPageRoute().go(context);
                }
              } on FirebaseAuthException catch (_) {
                if (context.mounted) {
                  ErrorDialog.show(
                      context: context, message: 'ログインに失敗しました。');
                }
              }
            },
            child: const Text('ログイン')
        ),
        ElevatedButton(
            onPressed: () {
              const SignUpPageRoute().push(context);
            },
            child: const Text('アカウント作成')
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authNotifierProvider.notifier).signInAnonymously();
                if (context.mounted) {
                  const TopPageRoute().go(context);
                }
              } on FirebaseAuthException catch (_) {
                if (context.mounted) {
                  ErrorDialog.show(
                      context: context, message: '認証に失敗しました。\n時間を空けて、お試しください。');
                }
              }
            },
            child: const Text('匿名認証')
        ),
      ],
    );
  }
}
