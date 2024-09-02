import 'package:flutter/material.dart';
import 'package:gemini_gui/chat/api.dart';
import 'package:gemini_gui/drawer/component.dart';
import 'package:gemini_gui/project/page.dart';
import 'package:gemini_gui/settings/page.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatAppDrawer extends HookConsumerWidget {
  const ChatAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Projects',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      context.push(const ProjectSettingsPage());
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const CustomProjectList(),
            const Divider(),
            const Expanded(
              child: ConversationList(),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: context.colorScheme.primary),
              title: Text('Settings',
                  style: TextStyle(color: context.colorScheme.primary)),
              onTap: () {
                context.push(const SettingsPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatAppDrawerLock extends ConsumerWidget {
  const ChatAppDrawerLock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worker = ref.watch(generateWorkerProvider);
    return worker == WorkerState.idle
        ? const ChatAppDrawer()
        : const SizedBox();
  }
}
