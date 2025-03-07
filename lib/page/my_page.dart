import 'package:asahiyama_go/routing/main_page_shell_route/main_page_shell_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../const/const.dart';
import '../model/profile/profile.dart';
import '../providers/auth_notifier/auth_notifier.dart';
import '../providers/comment_notifier/comment_notifier.dart';
import '../providers/post_notifier/post_notifier.dart';
import '../providers/profile_notifier/profile_notifier.dart';
import '../routing/routes.dart';
import '../ui_core/check_dialog.dart';
import '../ui_core/custom_snackbar.dart';
import '../ui_core/error_dialog.dart';

class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final profile = ref.watch(profileNotifierProvider).valueOrNull;
    final myPost = ref.watch(fetchMyPostProvider);
    final myLike = ref.watch(fetchMyLikeProvider);
    final myComment = ref.watch(fetchMyCommentProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Page', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _headerSection(profile),
              _tabSection(),
            ];
          },
          body: TabBarView(
            children: [
              myLike.when(
                data: (data) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(fetchMyLikeProvider);
                    },
                    child: data.isNotEmpty ?
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap:() {
                            PostDetailPageRoute(id: data[index]!.postsId).push(context);
                          },
                          child: CachedNetworkImage(
                            width: double.infinity,
                            imageUrl: data[index]!.postImageUrl,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        );
                       },
                    ):const _NoData(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text("エラー: $error"),
              ),
              myComment.when(
                data: (data) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(fetchMyCommentProvider);
                    },
                    child: data.isNotEmpty ?
                    ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(data[index]!.message!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                CheckDialog.show(
                                    context: context,
                                    message: 'コメントを削除しますか？',
                                    onOk: () async {
                                      try {
                                        await ref.read(commentNotifierProvider.notifier).delete(
                                            commentsId: data[index]!.commentsId,
                                            postsId: data[index]!.postsId,
                                            category: data[index]!.category
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            customSnackBar("コメントを削除しました"),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ErrorDialog.show(context: context, message: 'コメントの削除に失敗しました。');
                                        }
                                      }
                                    }
                                );
                              },
                            ),
                            onTap: () {
                              PostDetailPageRoute(id: data[index]!.postsId).push(context);
                            },
                          ),
                        );
                      },
                    ) : const _NoData(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text("エラー: $error"),
              ),
              myPost.when(
                data: (data) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(fetchMyPostProvider);
                    },
                    child: data.isNotEmpty ?
                    ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            PostDetailPageRoute(id: data[index]!.postsId).push(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  width: double.infinity,
                                  imageUrl: data[index]!.postImageUrl,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  children: [
                                    if (data[index]!.message != '')
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(data[index]!.message!),),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          CheckDialog.show(
                                              context: context,
                                              message: '投稿を削除しますか？',
                                              onOk: () async {
                                                try {
                                                  await ref.read(postNotifierProvider.notifier).delete(
                                                      postsId: data[index]!.postsId,
                                                      category: data[index]!.category,
                                                      imagePath: data[index]!.imagePath);
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      customSnackBar("投稿を削除しました"),
                                                    );
                                                  }
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ErrorDialog.show(context: context, message: '投稿の削除に失敗しました。');
                                                  }
                                                }
                                              }
                                          );
                                        },
                                        icon: const Icon(Icons.delete)
                                    ),
                                    const Gap(10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ) : const _NoData(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text("エラー: $error"),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('My Page', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            if (profile == null || profile.type != 0)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await ref.read(authNotifierProvider.notifier).signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar("ログアウトしました"),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        if (!context.mounted) return;
                        const SignInPageRoute().go(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ErrorDialog.show(
                            context: context,
                            message: 'ログアウトできません'
                        );
                      }
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      Gap(10),
                      Text('ログアウト')
                    ],
                  ),
                ),
              ),
            if (profile == null || profile.type == 0)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        enableDrag: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (context) {
                          return _BottomSheet();
                        });
                    },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.upgrade, color: Colors.white),
                      Gap(10),
                      Text('アカウント登録')
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (profile != null) {
                    CheckDialog.show(
                        context: context,
                        message: 'アカウントを削除しますか？\n投稿した内容、コメントは\n自動削除されません。',
                        onOk: () async {
                          try {
                            await ref.read(authNotifierProvider.notifier).delete(id: profile.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar("アカウントを削除しました"),
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              if (!context.mounted) return;
                              const SignInPageRoute().go(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ErrorDialog.show(
                                  context: context,
                                  message: 'アカウントの削除に失敗しました。'
                              );
                            }
                          }
                        }
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Gap(10),
                    Text('アカウント削除')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //header部分
  Widget _headerSection(Profile? profile) {
    if (profile == null) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            color: Colors.black.withOpacity(0.8),
            height: 40,
            child: Row(
              children: [
                const Spacer(),
                Text(_userName(profile), style: const TextStyle(color: Colors.white)),
                const Gap(15),
                const Icon(Icons.favorite, color: Colors.pinkAccent),
                const Gap(5),
                Text('${profile.likeCount ?? 0}', style: const TextStyle(color: Colors.white)),
                const Gap(15),
                const Icon(Icons.message, color: Colors.grey),
                const Gap(5),
                Text('${profile.commentCount ?? 0}', style: const TextStyle(color: Colors.white)),
                const Gap(15),
                const Icon(Icons.upload_file_sharp, color: Colors.blue),
                const Gap(5),
                Text('${profile.postCount ?? 0}', style: const TextStyle(color: Colors.white)),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

//TabBar部分
  Widget _tabSection() {
    return const SliverPersistentHeader(
      pinned: true,
      delegate: _StickyTabBarDelegate(
        tabBar: TabBar(
          labelColor: Colors.black,
          tabs: [
            Tab(
              icon: Icon(Icons.favorite, color: Colors.pinkAccent),
            ),
            Tab(
              icon: Icon(Icons.message, color: Colors.grey),
            ),
            Tab(
              icon: Icon(Icons.upload_file_sharp, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  String _userName(Profile? profile) {
    if (profile == null) return '';
    if (profile.name == '') return '未登録ユーザー';
    return profile.name!;
  }

}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 200),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: const Center(
              child: Text('データがありません。\n※未登録ユーザーの方は、\nアカウント登録後、\n以降の履歴が表示されます。',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
        );
      },
    );
  }
}


class _BottomSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Container(
        height: double.infinity,
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
            const Text('アカウント登録', style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold)),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: const OutlineInputBorder(),
                  labelText: 'ユーザーネーム',
                ),
              ),
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: const OutlineInputBorder(),
                  labelText: 'メールアドレス',
                ),
              ),
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: const OutlineInputBorder(),
                  labelText: 'パスワード',
                ),
              ),
            ),
            const Gap(30),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await ref.read(authNotifierProvider.notifier).linkWithCredential(
                        name: nameController.value.text,
                        email: emailController.value.text,
                        password: passwordController.value.text);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar("アカウント登録しました"),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;
                      const TopPageRoute().go(context);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (context.mounted) {
                      ErrorDialog.show(
                          context: context, message: handleException(e));
                    }
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('登録')
            ),
            const Gap(30),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: const Text('アカウント登録をおこなうと、\n画像の投稿機能や、コメント機能、いいね機能など、\nアプリのすべての機能がご利用いただけます。',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ],
        )
    );
  }
}

//SliverPersistentHeaderDelegateを継承したTabBarを作る
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
