import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/history.dart';
import 'package:gemini_gui/project/data.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomProjectList extends HookConsumerWidget {
  const CustomProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectListProvider);
    final selected = ref.watch(selectedProjectProvider);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 200,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ListTile(
            leading: selected == project.id
                ? Icon(Icons.folder_open, color: context.colorScheme.primary)
                : const Icon(Icons.folder),
            title: Text(project.title),
            onTap: () {
              ref.read(selectedProjectProvider.notifier).select(project.id);
              context.pop();
            },
          );
        },
      ),
    );
  }
}

class ConversationList extends HookConsumerWidget {
  const ConversationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedProjectProvider);
    final memo = useMemoized(() => ChatLogManager(projectId: id), [id]);
    final lenMemo = useMemoized(() => memo.length(), []);
    final len = useFuture(lenMemo);
    if (!len.hasData) {
      return const SizedBox();
    }
    final lenData = len.data;
    return ListView.builder(
      itemCount: lenData,
      itemBuilder: (context, index) {
        return FutureBuilder<ChatLogItem?>(
          future: memo.load(index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text('Error');
            }
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return ListTile(
                title: Text(data.title),
                onTap: () {
                  ref.read(chatHistoryProvider.notifier).load(data.id);
                  context.pop();
                },
              );
            }
            return const Text('No data');
          },
        );
      },
    );
  }
}
