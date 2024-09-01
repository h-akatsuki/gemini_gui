import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_gui/chat/api.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

RelativeRect? _lastLongPress;
void _reg(LongPressStartDetails details, BuildContext context) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      details.globalPosition,
      details.globalPosition,
    ),
    Offset.zero & overlay.size,
  );
  _lastLongPress = position;
}

class UserMessage extends HookWidget {
  final String message;
  final List<String> files;
  final Widget? versionWidget;
  final VoidCallback? onLongPress;

  const UserMessage({
    super.key,
    required this.message,
    this.files = const [],
    this.versionWidget,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _reg(details, context),
      onLongPress: onLongPress,
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              margin: const EdgeInsets.only(right: 16, top: 8, left: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MarkdownBody(
                    selectable: true,
                    data: message,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      code: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (files.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: files
                            .map((file) => FileComponent(fileName: file))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (versionWidget != null) versionWidget!,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class BotMessage extends HookWidget {
  final String message;
  final Widget? versionWidget;
  final VoidCallback? onLongPress;

  const BotMessage({
    super.key,
    required this.message,
    this.versionWidget,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _reg(details, context),
      onLongPress: onLongPress,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              margin: const EdgeInsets.only(right: 16, top: 8, left: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: MarkdownBody(
                selectable: true,
                data: message,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  code: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            if (versionWidget != null) versionWidget!,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class ErrorMessage extends HookWidget {
  final String errorMessage;
  final Widget? versionWidget;
  final VoidCallback? onLongPress;

  const ErrorMessage({
    super.key,
    required this.errorMessage,
    this.versionWidget,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onLongPressStart: (details) => _reg(details, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, left: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              errorMessage,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          ),
          if (versionWidget != null) versionWidget!,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class FileComponent extends StatelessWidget {
  final String fileName;

  const FileComponent({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(fileName,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}

class VersionSwitcher extends ConsumerWidget {
  final int index;

  const VersionSwitcher({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versions = ref
        .watch(chatHistoryProvider.select((value) => value.getVersion(index)));
    if (versions == null || versions.total == 1) {
      return const SizedBox();
    }
    final currentVersion = versions.current + 1;
    final totalVersions = versions.total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.chevron_left, size: 16),
            onPressed: currentVersion > 1
                ? () {
                    ref
                        .read(chatHistoryProvider.notifier)
                        .swich(index, currentVersion - 2);
                  }
                : null,
          ),
          Text('$currentVersion / $totalVersions',
              style: Theme.of(context).textTheme.labelSmall),
          IconButton(
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.chevron_right, size: 16),
            onPressed: currentVersion < totalVersions
                ? () {
                    ref
                        .read(chatHistoryProvider.notifier)
                        .swich(index, currentVersion);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class ChatBotLoading extends HookWidget {
  const ChatBotLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final dotAnimation = useAnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: useSingleTickerProvider(),
    )..repeat();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return FadeTransition(
              opacity: Tween(begin: 0.2, end: 1.0).animate(
                CurvedAnimation(
                  parent: dotAnimation,
                  curve: Interval(
                    index * 0.33,
                    (index + 1) * 0.33,
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSecondaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ChatbotCreating extends ConsumerWidget {
  const ChatbotCreating({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gen = ref.watch(generateWorkerProvider);
    final stream = ref.watch(generatingResponseProvider);
    if (gen == WorkerState.idle) {
      return const SizedBox();
    }
    if (stream) {
      return StreamBuilder(
        stream: streamingResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BotMessage(message: snapshot.data ?? '');
          } else {
            return const ChatBotLoading();
          }
        },
      );
    } else {
      return const ChatBotLoading();
    }
  }
}

class ModelSelecter extends ConsumerWidget {
  const ModelSelecter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedModel = ref.watch(selectedModelProvider);
    return Row(
      children: [
        Text(
          selectedModel.title,
          style: context.textTheme.titleMedium,
        ),
        PopupMenuButton(
          icon: const Icon(Icons.arrow_drop_down),
          itemBuilder: (context) => [
            for (final model in models)
              PopupMenuItem(
                value: model,
                child: Text(model.title),
              ),
          ],
          tooltip: 'Select model',
          onSelected: (GeminiModel model) {
            ref.read(selectedModelProvider.notifier).setModel(model);
          },
        ),
      ],
    );
  }
}

class AutoSwitchMessage extends ConsumerWidget {
  final int index;

  const AutoSwitchMessage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    botMenue(int index, String message) {
      showMenu(
        context: context,
        position: _lastLongPress ?? const RelativeRect.fromLTRB(100, 100, 0, 0),
        items: <PopupMenuEntry>[
          const PopupMenuItem(
            value: 'copy',
            child: ListTile(
              leading: Icon(Icons.content_copy),
              title: Text('Copy'),
            ),
          ),
          const PopupMenuItem(
            value: 'retry',
            child: ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Retry'),
            ),
          ),
        ],
      ).then((value) {
        if (value == 'copy') {
          Clipboard.setData(ClipboardData(text: message));
        } else if (value == 'retry') {
          ref.read(chatHistoryProvider.notifier).setlength(index);
          ref.read(generateWorkerProvider.notifier).generate();
        }
      });
    }

    final message =
        ref.watch(chatHistoryProvider.select((value) => value.getItem(index)));
    if (message == null) {
      return const SizedBox();
    }
    if (message.isUser) {
      return UserMessage(
        message: message.message,
        files: message.files.map((e) => e.name).toList(),
        versionWidget: VersionSwitcher(index: index),
        onLongPress: () {
          showMenu(
            context: context,
            position:
                _lastLongPress ?? const RelativeRect.fromLTRB(100, 100, 0, 0),
            items: <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'copy',
                child: ListTile(
                  leading: Icon(Icons.content_copy),
                  title: Text('Copy'),
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
            ],
          ).then(
            (value) {
              if (value == 'copy') {
                Clipboard.setData(ClipboardData(text: message.message));
              } else if (value == 'edit') {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditDialog(
                        initialText: message.message,
                        onConfirm: (value) {
                          final item =
                              ChatHistoryItem.user(value, files: message.files);
                          ref
                              .read(chatHistoryProvider.notifier)
                              .edit(index, item);
                          ref.read(generateWorkerProvider.notifier).generate();
                        },
                      );
                    },
                  );
                }
              }
            },
          );
        },
      );
    } else if (message.error) {
      return ErrorMessage(
        errorMessage: message.message,
        versionWidget: VersionSwitcher(index: index),
        onLongPress: () => botMenue(index, message.message),
      );
    } else {
      return BotMessage(
        message: message.message,
        versionWidget: VersionSwitcher(index: index),
        onLongPress: () => botMenue(index, message.message),
      );
    }
  }
}

class EditDialog extends HookWidget {
  final String initialText;
  final void Function(String) onConfirm;
  const EditDialog(
      {super.key, required this.initialText, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialText);
    return AlertDialog(
      title: const Text('Enter Text'),
      content: TextField(
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: 'Enter your text here',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: context.colorScheme.error),
          ),
        ),
        FilledButton(
          onPressed: () {
            onConfirm(controller.text);
            context.pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class Messages extends HookConsumerWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final len = ref.watch(chatHistoryProvider.select((value) => value.length));
    return ListView.builder(
      itemCount: len + 1,
      itemBuilder: (context, index) {
        if (index == len) {
          return const ChatbotCreating();
        }
        return AutoSwitchMessage(index: index);
      },
    );
  }
}

class LockIconButton extends ConsumerWidget {
  final Widget button;

  const LockIconButton({super.key, required this.button});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worker = ref.watch(generateWorkerProvider);
    return worker == WorkerState.idle
        ? button
        : IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {},
            tooltip: 'Generating...',
          );
  }
}
