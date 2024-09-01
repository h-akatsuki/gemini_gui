import 'package:flutter/material.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/home/component.dart';
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

  void clear() {
    state = [];
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: files
              .map(
                (file) => SelectedFileComponent(
                  file: file,
                  onDelete: () {
                    ref.read(chatInputFilesProvider.notifier).remove(file);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
