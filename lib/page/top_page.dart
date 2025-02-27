import 'package:asahiyama_go/routing/main_page_shell_route/main_page_shell_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/post/post.dart';
import '../providers/post_notifier/post_notifier.dart';
import '../routing/routes.dart';

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
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
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
          InkWell(
            onTap:() {
              PostDetailPageRoute(id: post.postId!).push(context);
            },
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.postImageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Align(alignment: Alignment.centerLeft, child: Text(post.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))),
          if (post.message != '')
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(alignment: Alignment.centerLeft, child: Text(post.message!, style: const TextStyle(fontSize: 15)))),
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
