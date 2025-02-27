import 'dart:io';

import 'package:asahiyama_go/model/app_version/app_version.dart';
import 'package:asahiyama_go/ui_core/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pub_semver/pub_semver.dart';

import 'providers/app_version/app_version_provider.dart';
import 'providers/package_info_instance/package_info_instance.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(
          () {
        bool shouldShowForceUpdateDialog(AppVersion? appVersion) {
          if (appVersion == null) {
            return false;
          }
          final versionText = ref.read(
            packageInfoInstanceProvider.select(
                  (v) => '${v.version}+${v.buildNumber}',
            ),
          );
          final version = Version.parse(versionText);
          return version < appVersion.version;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final platform = Platform.isIOS ? 'iOS' : 'android';
          final appVersion = await ref.read(
            getAppVersionProvider(
              platform: platform,
            ).future,
          );

          final shouldShow = shouldShowForceUpdateDialog(appVersion);
          if (shouldShow && context.mounted) {
            UpdateDialog.show(context: context);
          }

        });
        return null;
      },
      const [],
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.blue.withOpacity(0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: '',
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }

}
