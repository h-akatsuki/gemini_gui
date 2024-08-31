import 'package:flutter/material.dart';
import 'package:gemini_gui/camera/page.dart';
import 'package:gemini_gui/chat/api.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/home/page.dart';
import 'package:gemini_gui/settings/component.dart';
import 'package:gemini_gui/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> initPathTask() async {
  await initPath();
  await initDb();
  await initTheme();
  await initApiKey();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initPathTask(),
    initCameras(),
  ]);
  runApp(const ProviderScope(child: GeminiGUI()));
}

class GeminiGUI extends ConsumerWidget {
  const GeminiGUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const theme = MaterialTheme(TextTheme());
    final themeMode = ref.watch(themeStateProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: theme.dark(),
      theme: theme.light(),
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
