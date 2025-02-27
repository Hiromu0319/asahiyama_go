import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/post/post.dart';
import '../providers/comment_notifier/comment_notifier.dart';
import '../providers/profile_notifier/profile_notifier.dart';
import 'custom_snackbar.dart';
import 'error_dialog.dart';

class PostCommentBottomSheet extends HookConsumerWidget {
  final Post post;
  final String id;
  const PostCommentBottomSheet({required this.post, required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final profile = ref.watch(profileNotifierProvider).valueOrNull;
    final commentController = useTextEditingController();

    return Container(
      height: 400,
      width: double.infinity,
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
          const Text('Send a comment on a great photo!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextFormField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: const OutlineInputBorder(),
                labelText: 'コメントを入力してね！',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if (profile == null || profile.type == 0) {
                  await _anonymousUserAlertDialog(context); return;
                }

                try {
                  ref.read(commentNotifierProvider.notifier).post(
                      name: profile.name ?? '',
                      postsId: id,
                      postImageUrl: post.postImageUrl,
                      targetUserId: post.userId,
                      pushToken: post.pushToken,
                      category: post.category,
                      notificationId: '',
                      message: commentController.value.text
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar("コメントを送信しました"),
                    );
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    ErrorDialog.show(
                        context: context, message: e.toString());
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
              child: const Text('送信')
          ),
        ],
      ),
    );
  }

  Future<void> _anonymousUserAlertDialog(BuildContext context) async {
    ErrorDialog.show(
        context: context,
        message: '未登録ユーザーの方は、\nコメント機能を\nご利用いただけません。\nマイページから、\nアカウント登録を\nお願いいたします。'
    );
  }

}