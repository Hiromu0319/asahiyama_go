import 'package:asahiyama_go/routing/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes.dart';
import '../../main_page.dart';

part 'main_page_shell_route.g.dart';

@TypedShellRoute<AppShellRoute>(routes: [
  TypedStatefulShellRoute<MainPageShellRoute>(
    branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
      TypedStatefulShellBranch<StatefulShellBranchData>(
        routes: [
          TypedGoRoute<TopPageRoute>(
            path: TopPageRoute.path,
          ),
        ],
      ),
      TypedStatefulShellBranch<StatefulShellBranchData>(
        routes: [
          TypedGoRoute<SearchPageRoute>(
            path: SearchPageRoute.path,
          ),
        ],
      ),
      TypedStatefulShellBranch<StatefulShellBranchData>(
        routes: [
          TypedGoRoute<PostPageRoute>(
            path: PostPageRoute.path,
          ),
        ],
      ),
      TypedStatefulShellBranch<StatefulShellBranchData>(
        routes: [
          TypedGoRoute<NotificationPageRoute>(
            path: NotificationPageRoute.path,
          ),
        ],
      ),
      TypedStatefulShellBranch<StatefulShellBranchData>(
        routes: [
          TypedGoRoute<MyPageRoute>(
            path: MyPageRoute.path,
          ),
        ],
      ),
    ],
  ),
  TypedGoRoute<SignInPageRoute>(
    path: SignInPageRoute.path,
    routes: [
      TypedGoRoute<SignUpPageRoute>(
        path: SignUpPageRoute.path,
      ),
    ],
  ),
])

class AppShellRoute extends ShellRouteData {
  const AppShellRoute();

  static final $navigationKey = rootNavigatorKey;

  @override
  Widget builder(
      BuildContext context,
      GoRouterState state,
      Widget navigator
  ) {
    return Scaffold(body: navigator);
  }
}

class MainPageShellRoute extends StatefulShellRouteData {
  const MainPageShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainPage(navigationShell: navigationShell);
  }
}
