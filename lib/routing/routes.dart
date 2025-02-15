import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../page/login_page.dart';
import '../page/my_page.dart';
import '../page/notification_page.dart';
import '../page/post_page.dart';
import '../page/search_page.dart';
import '../page/top_page.dart';

class LoginPageRoute extends GoRouteData {
  const LoginPageRoute();

  static const path = '/login';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
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

class NotificationPageRoute extends GoRouteData {
  const NotificationPageRoute();

  static const path = '/notification';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationPage();
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