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
    initialLocation: LoginPageRoute.path,
  );
}
