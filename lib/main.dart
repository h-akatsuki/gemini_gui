import 'package:flutter/material.dart';
import 'package:gemini_gui/home/page.dart';
import 'package:gemini_gui/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: GeminiGUI()));
}

class GeminiGUI extends ConsumerWidget {
  const GeminiGUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const theme = MaterialTheme(TextTheme());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: theme.dark(),
      theme: theme.light(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
