import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/post_notifier/post_notifier.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPost = ref.watch(fetchPostCategoryProvider(category: 'cat'));

    return myPost.when(
      data: (data) {
        return Column(
          children: List.generate(data.length, (index) =>
              Image.network(data[index].postImageUrl, height: 80)),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text("エラー: $error"),
    );
  }
}