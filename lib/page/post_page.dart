import 'dart:io';

import 'package:asahiyama_go/providers/post_notifier/post_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../ui_core/error_dialog.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final image = useState<XFile?>(null);
    final commentController = useTextEditingController();

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
              padding: const EdgeInsets.all(50),
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
              child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('投稿')
              ),
            ),
          )
        ],
      ),
    );

    // return Center(
    //     child: IconButton(
    //         onPressed: () async {
    //           final ImagePicker picker = ImagePicker();
    //           final XFile? image =
    //               await picker.pickImage(source: ImageSource.gallery);
    //
    //           if (image == null) {
    //             return;
    //           }
    //
    //           try {
    //             ref.read(postNotifierProvider.notifier).upload(category: 'cat', name: 'あ', image: image, pushToken: 'a');
    //           } catch (e) {
    //             if (context.mounted) {
    //               ErrorDialog.show(context: context, message: '失敗しました。');
    //             }
    //           }
    //
    //         },
    //         icon: const Icon(Icons.add)
    //     ),
    // );
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
