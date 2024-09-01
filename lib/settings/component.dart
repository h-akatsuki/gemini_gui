import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemini_gui/chat/api.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'component.g.dart';

const _themeKey = '__theme__';

ThemeMode? _themeMode;

Future<void> initTheme() async {
  final key = await getKV(_themeKey);
  if (key != null) {
    _themeMode = switch (key) {
      's' => ThemeMode.system,
      'l' => ThemeMode.light,
      'd' => ThemeMode.dark,
      _ => null,
    };
  }
}

@Riverpod(keepAlive: true)
class ThemeState extends _$ThemeState {
  @override
  ThemeMode build() {
    return _themeMode ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await save();
  }

  Future<void> save() async {
    final key = switch (state) {
      ThemeMode.system => 's',
      ThemeMode.light => 'l',
      ThemeMode.dark => 'd',
    };
    await setKV(_themeKey, key);
  }
}

class SettingsToggle extends HookConsumerWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: context.colorScheme.primary,
      ),
    );
  }
}

class SettingsTextField extends HookConsumerWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String label;

  const SettingsTextField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: useTextEditingController(text: value),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class SettingsSecretTextField extends HookConsumerWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String label;

  const SettingsSecretTextField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscureText = useState(true);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: useTextEditingController(text: value),
        onChanged: onChanged,
        obscureText: obscureText.value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText.value ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => obscureText.value = !obscureText.value,
          ),
        ),
      ),
    );
  }
}

class SettingsThemeSelector extends HookConsumerWidget {
  const SettingsThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeStateProvider);

    return ListTile(
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        value: themeMode,
        onChanged: (ThemeMode? newValue) {
          if (newValue != null) {
            ref.read(themeStateProvider.notifier).setThemeMode(newValue);
          }
        },
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
        ],
      ),
    );
  }
}

class ApiKeyTextField extends HookConsumerWidget {
  const ApiKeyTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKey = ref.watch(apiKeyProvider);

    return SettingsSecretTextField(
      value: apiKey ?? '',
      onChanged: ref.read(apiKeyProvider.notifier).set,
      label: 'API Key',
    );
  }
}

@riverpod
class ChatInstructionTemp extends _$ChatInstructionTemp {
  @override
  String? build() {
    ref.onDispose(() {
      if (state == null) {
        return;
      }
      ref.read(chatInstructionProvider.notifier).set(state!);
    });
    return null;
  }

  void set(String instruction) => state = instruction;
}

class ChatInstructionInput extends HookConsumerWidget {
  const ChatInstructionInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatInstruction = ref.watch(chatInstructionProvider);
    ref.watch(chatInstructionTempProvider.select((value) => null));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: chatInstruction.when(
        data: (data) => ChatInstructionInputInner(initialValue: data),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}

class ChatInstructionInputInner extends HookConsumerWidget {
  final String initialValue;

  const ChatInstructionInputInner({super.key, required this.initialValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: initialValue);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Chat Instruction',
        hintText: 'Enter custom chat instruction',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            ref.read(chatInstructionProvider.notifier).set(controller.text);
          },
        ),
      ),
      maxLines: 7,
      onChanged: (value) {
        ref.read(chatInstructionTempProvider.notifier).set(value);
      },
    );
  }
}
