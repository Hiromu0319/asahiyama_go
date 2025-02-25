import 'package:asahiyama_go/providers/like_notifier/like_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/post/post.dart';
import '../providers/comment_notifier/comment_notifier.dart';
import '../providers/post_notifier/post_notifier.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final posts = ref.watch(fetchPostProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Asahiyama Go!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          const SliverToBoxAdapter(
            child: Row(
              children: [
                Gap(20),
                Text(
                  '最近の投稿',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          posts.when(
              data: (data) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return ImageFlame(post: data[index]);
                      },
                      childCount: data.length
                  ),
                );
              },
            loading: () => const SliverToBoxAdapter(child: const CircularProgressIndicator()),
            error: (error, _) => SliverToBoxAdapter(child: Text("エラー: $error")),
          )
        ],
      ),
    );
  }

}

class ImageFlame extends ConsumerWidget {
  final Post post;
  const ImageFlame({
    required this.post,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            imageUrl: post.postImageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Align(alignment: Alignment.centerLeft, child: Text(post.name))),
          if (post.message != '')
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(post.message!),),
          Row(
            children: [
              const Gap(5),
              const Icon(Icons.favorite, color: Colors.pinkAccent),
              const Gap(5),
              Text('${post.likeCount}', style: const TextStyle(fontSize: 20)),
              const Gap(10),
              const Icon(Icons.message, color: Colors.grey),
              const Gap(5),
              Text('${post.commentCount}', style: const TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}

// Column(
// children: List.generate(data.length, (index) => Column(
//   children: [
//     Image.network(data[index].postImageUrl),
//     Text('${data[index].likeCount}'),
//     IconButton(
//         onPressed: () async {
//
//           final result = await ref.read(likeNotifierProvider.notifier).check(postsId: data[index].postId!);
//           if (result) return;
//
//           ref.read(likeNotifierProvider.notifier).increment(
//               name: '',
//               postsId: data[index].postId!,
//               postImageUrl: data[index].postImageUrl,
//               targetUserId: 'a',
//               pushToken: '',
//               category: 'cat',
//               notificationId: 'a'
//           );
//         },
//         icon: const Icon(Icons.add)
//     ),
//     IconButton(
//         onPressed: () {
//
//           ref.read(commentNotifierProvider.notifier).post(
//               name: '',
//               postsId: data[index].postId!,
//               postImageUrl: data[index].postImageUrl,
//               targetUserId: 'a',
//               pushToken: '',
//               category: 'cat',
//               notificationId: 'a',
//               message: 'いいね！'
//           );
//         },
//         icon: const Icon(Icons.message)
//     ),
//   ],
// )),
//);