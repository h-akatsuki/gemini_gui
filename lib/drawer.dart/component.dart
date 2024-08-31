import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'component.g.dart';

@riverpod
class SelectedProject extends _$SelectedProject {
  @override
  String? build() {
    return null;
  }

  void set(String value) {
    state = value;
  }

  void clear() {
    state = null;
  }
}

class CustomProjectItem {
  final String icon;
  final String title;

  CustomProjectItem({required this.icon, required this.title});
}

class ConversationItem {
  final String title;

  ConversationItem({required this.title});
}

class CustomProjectList extends HookConsumerWidget {
  final List<CustomProjectItem> models;

  const CustomProjectList({super.key, required this.models});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedProjectProvider);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        return ListTile(
          leading: Icon(
              IconData(int.parse(model.icon), fontFamily: 'MaterialIcons')),
          title: Text(model.title),
          selected: selected == model.title,
          onTap: () => {
            ref.read(selectedProjectProvider.notifier).set(model.title),
          },
        );
      },
    );
  }
}

class ConversationList extends StatelessWidget {
  final List<ConversationItem> conversations;

  const ConversationList({super.key, required this.conversations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ListTile(
          leading: const Icon(Icons.chat_bubble_outline),
          title: Text(conversation.title),
          onTap: () {
            // TODO: Handle conversation selection
          },
        );
      },
    );
  }
}
