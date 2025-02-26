import 'package:asahiyama_go/providers/comment_notifier/comment_notifier.dart';
import 'package:asahiyama_go/providers/post_notifier/post_notifier.dart';
import 'package:asahiyama_go/ui_core/post_comment_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/post/post.dart';

class PostDetailPage extends ConsumerWidget {
  final String id;
  const PostDetailPage({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final postInformation = ref.watch(postInformationProvider(id:id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              'Information', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          postInformation.when(
            data: (data) {
              return SliverToBoxAdapter(
                  child: data != null ?
                      PostInformation(post: data, id: id):
                      const Center(child: Text('データが見つかりませんでした。'))
              );
            },
            loading: () => const SliverToBoxAdapter(child: CircularProgressIndicator()),
            error: (error, _) => SliverToBoxAdapter(child: Text("エラー: $error")),
          ),
          postInformation.when(
            data: (data) {
              return data != null ?
              CommentLog(comments: data.comments):
              const SliverToBoxAdapter(child: Center(child: Text('コメントが見つかりませんでした。')));
            },
            loading: () => const SliverToBoxAdapter(child: CircularProgressIndicator()),
            error: (error, _) => SliverToBoxAdapter(child: Text("エラー: $error")),
          ),
        ],
      ),
    );
  }
}

class PostInformation extends StatelessWidget {
  final Post post;
  final String id;
  const PostInformation({
    required this.post,
    required this.id,
    super.key
  });

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      enableDrag: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) {
                        return PostCommentBottomSheet(post: post, id: id);
                      });
                },
                icon: const Icon(Icons.message, color: Colors.grey),
              ),
              Text('${post.commentCount}', style: const TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentLog extends ConsumerWidget {
  final List<String>? comments;
  const CommentLog({required this.comments, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if (comments == null) return const SliverToBoxAdapter(child: Text('コメントがありません'));
    if (comments!.isEmpty) return const SliverToBoxAdapter(child: Text('コメントがありません'));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          child: ListTile(
            title: ref.watch(commentInformationProvider(id:comments![index])).when(
              data: (data) {
                return Text(data!.message, style: const TextStyle(fontWeight: FontWeight.bold));
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text("エラー: $error"),
            ),
            subtitle: ref.watch(commentInformationProvider(id:comments![index])).when(
              data: (data) {
                return Text(data!.name);
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text("エラー: $error"),
            ),
          ),
        ),
        childCount: comments!.length,
      ),
    );
  }
}
