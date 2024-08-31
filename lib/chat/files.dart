import 'package:flutter/material.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files.g.dart';

@Riverpod(keepAlive: true)
class ChatInputFiles extends _$ChatInputFiles {
  @override
  List<ChatFileItem> build() {
    return [];
  }

  void add(ChatFileItem item) {
    state = [...state, item];
  }

  void remove(ChatFileItem item) {
    state = state.where((e) => e != item).toList();
  }

  List<ChatFileItem> take() {
    final result = state;
    state = [];
    return result;
  }
}

class ChatInputFileView extends ConsumerWidget {
  const ChatInputFileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(chatInputFilesProvider);
    if (files.isEmpty) {
      return const SizedBox();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: files.map((e) {
        return Chip(
          label: Text(e.name),
          onDeleted: () {
            ref.read(chatInputFilesProvider.notifier).remove(e);
          },
        );
      }).toList(),
    );
  }
}