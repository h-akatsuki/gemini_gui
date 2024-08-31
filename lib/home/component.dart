import 'package:flutter/material.dart';
import 'package:gemini_gui/chat/component.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'component.g.dart';

@riverpod
class SelectedModel extends _$SelectedModel {
  @override
  String build() => '1.5 Pro (0827)';

  void setModel(String model) => state = model;
}

class ChatAppHeader extends HookConsumerWidget {
  final VoidCallback drawerOpen;
  const ChatAppHeader({super.key, required this.drawerOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: drawerOpen,
        tooltip: 'Open menu',
      ),
      title: const ModelSelecter(),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // TODO: Start new chat
          },
          tooltip: 'New chat',
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
