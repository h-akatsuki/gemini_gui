import 'package:flutter/material.dart';
import 'package:gemini_gui/settings/component.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          ApiKeyTextField(),
          SettingsThemeSelector(),
          ChatInstructionInput(),
        ],
      ),
    );
  }
}
