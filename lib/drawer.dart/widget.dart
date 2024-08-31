import 'package:flutter/material.dart';
import 'package:gemini_gui/drawer.dart/component.dart';
import 'package:gemini_gui/settings/page.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatAppDrawer extends HookConsumerWidget {
  const ChatAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Projects',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const CustomProjectList(models: [
                      //TODO: Add custom models
                    ]),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Conversations',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const ConversationList(conversations: [
                      //TODO: Add conversations
                    ]),
                  ],
                ),
              ),
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
