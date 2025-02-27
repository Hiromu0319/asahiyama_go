import 'package:asahiyama_go/providers/auth_notifier/auth_notifier.dart';
import 'package:asahiyama_go/ui_core/check_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../const/const.dart';
import '../ui_core/custom_snackbar.dart';
import '../ui_core/error_dialog.dart';
import '../routing/routes.dart';
import '../routing/main_page_shell_route/main_page_shell_route.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Asahiyama Go!",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: const OutlineInputBorder(),
                labelText: 'メールアドレス',
              ),
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: const OutlineInputBorder(),
                labelText: 'パスワード',
              ),
            ),
          ),
          const Gap(30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  try {
                    await ref.read(authNotifierProvider.notifier).signIn(
                        email: emailController.value.text,
                        password: passwordController.value.text);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar("ログインしました"),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;
                      const TopPageRoute().go(context);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (context.mounted) {
                      ErrorDialog.show(
                          context: context, message: handleException(e));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ログイン')
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('アカウントをお持ちでないですか？', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () async {
                    await showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        enableDrag: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (context) {
                          return _BottomSheet();
                        });
                  },
                  child: const Text('登録する', style: TextStyle(color: Colors.blue))
              ),
            ],
          ),
          const Gap(30),
          Text('初回利用の方へ', style: TextStyle(color: Colors.red.withOpacity(0.7), fontWeight: FontWeight.bold)),
          const Gap(10),
          const Text('アカウント登録せずに利用も可能です', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const Text('※画像の閲覧のみ可能です', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  try {
                    await ref.read(authNotifierProvider.notifier).signInAnonymously();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar("ログインしました"),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;
                      const TopPageRoute().go(context);
                    }
                  } on FirebaseAuthException catch (_) {
                    if (context.mounted) {
                      ErrorDialog.show(
                          context: context, message: '認証に失敗しました。\n時間を空けて、お試しください。');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('自動ログインでお試し利用する')
            ),
          ),
        ],
      ),
    );
  }

}

class _BottomSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      margin: const EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('新規登録', style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold)),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: const OutlineInputBorder(),
                labelText: 'ユーザーネーム',
              ),
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: const OutlineInputBorder(),
                labelText: 'メールアドレス',
              ),
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: const OutlineInputBorder(),
                labelText: 'パスワード',
              ),
            ),
          ),
          const Gap(30),
          ElevatedButton(
              onPressed: () async {
                CheckDialog.show(
                    context: context,
                    message: 'この内容で\n新規登録しますか？',
                    onOk: () async {
                      try {
                        await ref.read(authNotifierProvider.notifier).signUp(
                            name: nameController.value.text,
                            email: emailController.value.text,
                            password: passwordController.value.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar("新規登録しました"),
                          );
                          await Future.delayed(const Duration(seconds: 2));
                          if (!context.mounted) return;
                          const TopPageRoute().go(context);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          ErrorDialog.show(
                              context: context, message: handleException(e));
                        }
                      }
                    }
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('登録')
          ),
          const Gap(30),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: const Text('新規登録をおこなうと、\n画像の投稿機能や、コメント機能、いいね機能など、\nアプリのすべての機能がご利用いただけます。',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
          ],
      )
    );
  }
}