import 'package:asahiyama_go/routing/main_page_shell_route/main_page_shell_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../const/const.dart';
import '../providers/post_notifier/post_notifier.dart';
import '../routing/routes.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedCategory = useState<String?>(null);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 150,
            backgroundColor: Colors.blueAccent,
            title: const Text("動物ごとに検索"),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                ],
              ),
            ),
          ),
          ref.watch(fetchPostCategoryProvider(
              category: selectedCategory.value ?? 'ホッキョクグマ')).when(
            data: (data) {
              return data.isNotEmpty ?
                SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return InkWell(
                      onTap: () {
                        PostDetailPageRoute(id: data[index].postId!).push(context);
                      },
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: data[index].postImageUrl,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  childCount: data.length,
                ),
              ) : const SliverToBoxAdapter(child: NoImage());
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (error, _) => SliverToBoxAdapter(child: Text("エラー: $error")),
          )
        ],
      ),
    );
  }
}

class NoImage extends StatelessWidget {
  const NoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(30),
        Icon(Icons.search_off, size: 50),
        Gap(10),
        Text('検索結果はありません')
      ],
    );
  }
}
