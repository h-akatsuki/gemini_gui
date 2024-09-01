import 'package:flutter/material.dart';
import 'package:gemini_gui/chat/component.dart';
import 'package:gemini_gui/project/data.dart';
import 'package:gemini_gui/project/page.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectHeader extends ConsumerWidget {
  const ProjectHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    if (project == null) {
      return const SizedBox();
    }
    ProjectInfo? data;
    final projectList = ref.watch(projectListProvider);
    for (final item in projectList) {
      if (item.id == project) {
        data = item;
        break;
      }
    }
    if (data == null) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: context.colorScheme.tertiaryContainer,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    context.safePush(ProjectSettingsPage(id: data!.id));
                  },
                ),
                Text(
                  data.title,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.tertiary,
                    fontSize: context.textTheme.titleMedium?.fontSize,
                  ),
                ),
              ],
            ),
          ),
          LockIconButton(
            button: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                ref.read(selectedProjectProvider.notifier).clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
