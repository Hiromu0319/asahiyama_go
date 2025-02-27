import 'package:asahiyama_go/page/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../page/sign_in_page.dart';
import '../page/my_page.dart';
import '../page/post_page.dart';
import '../page/search_page.dart';
import '../page/top_page.dart';

class SignInPageRoute extends GoRouteData {
  const SignInPageRoute();

  static const path = '/signIn';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInPage();
  }
}

class TopPageRoute extends GoRouteData {
  const TopPageRoute();

  static const path = '/top';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TopPage();
  }
}

class SearchPageRoute extends GoRouteData {
  const SearchPageRoute();

  static const path = '/search';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchPage();
  }
}

class PostPageRoute extends GoRouteData {
  const PostPageRoute();

  static const path = '/post';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PostPage();
  }
}

class MyPageRoute extends GoRouteData {
  const MyPageRoute();

  static const path = '/myPage';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyPage();
  }
}

class PostDetailPageRoute extends GoRouteData {
  final String id;
  const PostDetailPageRoute({required this.id});

  static const path = 'postDetail';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PostDetailPage(id: id);
  }
}