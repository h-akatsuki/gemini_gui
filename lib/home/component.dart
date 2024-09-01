import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemini_gui/chat/component.dart';
import 'package:gemini_gui/chat/files.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/settings/page.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;
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
      leading: LockIconButton(
        button: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: drawerOpen,
          tooltip: 'Open menu',
        ),
      ),
      title: const ModelSelecter(),
      actions: [
        LockIconButton(
          button: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ref.read(chatInputFilesProvider.notifier).clear();
              ref.read(chatHistoryProvider.notifier).clear();
            },
            tooltip: 'New chat',
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class SelectedFileComponent extends HookWidget {
  final ChatFileItem file;
  final VoidCallback onDelete;

  const SelectedFileComponent({
    super.key,
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = file.mimeType.startsWith('image/');
    return SizedBox(
      key: ValueKey(("file", file.id)),
      width: 100,
      height: 100,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isImage) FileImage(file: file) else _buildFileInfo(context),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDelete,
                style: IconButton.styleFrom(
                  backgroundColor:
                      context.colorScheme.tertiaryContainer.withOpacity(0.7),
                  foregroundColor: context.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            path.extension(file.name).toUpperCase().substring(1),
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            file.name,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class FileImage extends HookWidget {
  final ChatFileItem file;

  const FileImage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final memo = useMemoized(() => loadFile(file.id), [file.id]);
    final snapshot = useFuture(memo);

    return switch (snapshot) {
      AsyncSnapshot(hasData: true, data: final data?) => Image.memory(
          data,
          fit: BoxFit.cover,
        ),
      AsyncSnapshot(hasError: true) => _buildErrorWidget(context),
      _ => _buildLoadingWidget(context),
    };
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      color: context.colorScheme.errorContainer,
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: context.colorScheme.onErrorContainer,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}

class APIKeyIsNotSet extends StatelessWidget {
  const APIKeyIsNotSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'API key is not set',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Please set API key in settings',
            style: context.textTheme.bodyMedium,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
                context.push(const SettingsPage());
              },
              child: const Text('Open settings'),
            ),
          ),
        ],
      ),
    );
  }
}