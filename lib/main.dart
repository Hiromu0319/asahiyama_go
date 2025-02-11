import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'providers/package_info_instance/package_info_instance.dart';
import 'providers/shared_preferences_instance/shared_preferences_instance.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initSharedPreferencesInstance();
  await initPackageInfoInstance();

  runApp(const ProviderScope(child: App()));
}