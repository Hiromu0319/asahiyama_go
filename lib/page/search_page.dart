import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/post_notifier/post_notifier.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final List<String> categories = [
      "ホッキョクグマ",
      "トナカイ",
      "シロフクロウ",
      "カバ",
      "キリン",
      "ライオン",
      "シロフクロウ",
      "ブラッザグエノン",
      "チンパンジー",
      "アビシニアコロンブス",
      "ワオキツネザル",
      "ダチョウ",
      "ヨーロッパフラミンゴ",
      "マヌルネコ",
      "エゾモモンガ",
      "タンチョウ",
      "ゴマフアザラシ",
      "アムールトラ",
      "アムールヒョウ",
      "ユキヒョウ",
      "ボルネオオランウータン",
      "シロテテナガザル",
      "キョン",
      "シセンレッサーバンダ",
      "ニホンザル",
      "エゾシカ",
      "エゾヒグマ",
      "キタキツネ",
      "エゾタヌキ",
      "エゾユキウサギ",
      "エゾクロテン",
      "エゾリス",
      "エゾフクロウ",
      "シマフクロウ",
      "オオワシ",
      "オジロワシ",
      "クマタカ",
      "オオハクチョウ",
      "キンクロハジロ",
      "インドクジャク",
      "アオダイショウ",
      "シンリンオオカミ",
      "アライグマ",
      "ジェフロイクモザル",
      "カピバラ",
      "フンボルトペンギン",
      "チリーフラミンゴ",
      "ベニイロフラミンゴ",
      "キングペンギン",
      "ジェンツーペンギン",
      "イワトビペンギン"
    ];

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
                    return CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: data[index].postImageUrl,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    );
                  },
                  childCount: data.length,
                ),
              ) : const SliverToBoxAdapter(child: Text("画像はありません"));
            },
            loading: () => const SliverToBoxAdapter(child: CircularProgressIndicator()),
            error: (error, _) => SliverToBoxAdapter(child: Text("エラー: $error")),
          )
        ],
      ),
    );
  }
}