import 'package:asahiyama_go/providers/auth_notifier/auth_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main_page_shell_route/main_page_shell_route.dart';
import '../routes.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      ...$appRoutes,
    ],
    debugLogDiagnostics: kDebugMode,
    initialLocation: SignInPageRoute.path,
    redirect: (BuildContext context, GoRouterState state) async {
      final authState = ref.watch(authNotifierProvider);
      if (authState == null) {
        return SignInPageRoute.path;
      } else {
        if (state.matchedLocation == SignInPageRoute.path) {
          return TopPageRoute.path;
        }
      }
      return null;
    }
  );
}
