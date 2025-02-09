import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes.dart';
import '../../main_page.dart';

part 'main_page_shell_route.g.dart';

@TypedStatefulShellRoute<MainPageShellRoute>(
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
)
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
