import 'package:a2_jawwada/routing/router.dart';
import 'package:a2_jawwada/ui/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  usePathUrlStrategy();
  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(theme: appTheme, routerConfig: router);
  }
}
