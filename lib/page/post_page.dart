import 'package:asahiyama_go/providers/post_notifier/post_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../ui_core/error_dialog.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image == null) {
                return;
              }

              try {
                ref.read(postNotifierProvider.notifier).upload(category: 'cat', name: 'あ', image: image, pushToken: 'a');
              } catch (e) {
                if (context.mounted) {
                  ErrorDialog.show(context: context, message: '失敗しました。');
                }
              }

            },
            icon: const Icon(Icons.add)
        ),
    );
  }
}
