import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../const/const.dart';
import '../providers/post_notifier/post_notifier.dart';
import '../providers/profile_notifier/profile_notifier.dart';
import '../ui_core/custom_snackbar.dart';
import '../ui_core/error_dialog.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedCategory = useState<String?>(null);
    final image = useState<XFile?>(null);
    final commentController = useTextEditingController();

    final profile = ref.watch(profileNotifierProvider).valueOrNull;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              '新規投稿', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
          ),
          SliverToBoxAdapter(
            child: image.value != null ?
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.file(File(image.value!.path), width: double.infinity, height: 300, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () async {
                      image.value = null;
                    },
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.remove),
                  ),
                ),
              ],
            ) :
            Stack(
              children: [
                _noImage(),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? choiceImage = await picker.pickImage(source: ImageSource.gallery);
                      image.value = choiceImage;
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory.value,
                    hint: const Text("種類を選択"),
                    isExpanded: true,
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedCategory.value = newValue;
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextFormField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: const OutlineInputBorder(),
                  labelText: 'コメントがあれば入力してね！',
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (profile!.type == 0) return;

                        try {
                          ref.read(postNotifierProvider.notifier).upload(
                              category: selectedCategory.value!,
                              name: profile.name!,
                              image: image.value!,
                              message: commentController.value.text,
                              pushToken: 'a');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar("画像の投稿が完了しました"),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ErrorDialog.show(context: context, message: '画像のアップロードに\n失敗しました。');
                          }
                        }

                        await Future.delayed(const Duration(seconds: 2));

                        image.value = null;
                        selectedCategory.value = null;
                        commentController.clear();

                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: (profile == null || profile.type != 0) ? Colors.blue : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('投稿')
                  ),
                  const Gap(5),
                  if (profile!.type == 0)
                    const Text('未登録ユーザーの方は、\n写真の投稿機能は利用できません。', style: TextStyle(color: Colors.redAccent), textAlign: TextAlign.center)
                ],
              ),
            ),
          )
        ],
      ),
    );

  }
  
  Widget _noImage() {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.perm_media, size: 50, color: Colors.white),
          Text('メディアがありません', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('写真がここに表示されます。', style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }
  
}
