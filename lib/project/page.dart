import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/db/file.dart';
import 'package:gemini_gui/home/component.dart';
import 'package:gemini_gui/project/data.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectSettingsPage extends HookConsumerWidget {
  final int? id;
  const ProjectSettingsPage({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null) {
      return const ProjectSettingsPageInner(
        initialTitle: 'Project Title',
        initialCustomInstruction: '',
        initialFiles: [],
      );
    }
    final project = ref.read(projectListProvider
        .select((value) => value.firstWhere((e) => e.id == id)));
    final memo = useMemoized(() async {
      final data = await loadProject(id!);
      return ProjectData.fromJson(jsonDecode(data!));
    });
    final data = useFuture(memo);
    if (data.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data.hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Project Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: Center(
          child: Text('Error: ${data.error}'),
        ),
      );
    }
    return ProjectSettingsPageInner(
      id: id,
      initialTitle: project.title,
      initialCustomInstruction: data.data!.customInstruction,
      initialFiles: data.data!.files,
    );
  }
}

class ProjectSettingsPageInner extends HookConsumerWidget {
  final int? id;
  final String initialTitle;
  final String initialCustomInstruction;
  final List<ChatFileItem> initialFiles;
  const ProjectSettingsPageInner({
    super.key,
    this.id,
    required this.initialTitle,
    required this.initialCustomInstruction,
    required this.initialFiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: initialTitle);
    final customInstructionController =
        useTextEditingController(text: initialCustomInstruction);
    final files = useState<List<ChatFileItem>>(initialFiles);
    final save = useMemoized(() => WrapObject(true), []);
    return PopScope(
      onPopInvokedWithResult: (b, d) async {
        if (!save.value) return;
        final data = ProjectData(
          customInstruction: customInstructionController.text,
          files: files.value,
        );
        if (id == null) {
          await ref.read(projectListProvider.notifier).add(
                titleController.text,
                data,
              );
        } else {
          await ref.read(projectListProvider.notifier).update(
                id!,
                title: titleController.text,
                data: data,
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Project Settings'),
          actions: [
            if (id != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  save.value = false;
                  await ref.read(projectListProvider.notifier).remove(id!);
                  if (context.mounted) Navigator.of(context).pop();
                },
              )
            else
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  save.value = false;
                  context.pop();
                },
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Edit Title', style: context.textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter assistant title',
              ),
            ),
            const SizedBox(height: 24),
            Text('Uploaded Files', style: context.textTheme.titleLarge),
            const SizedBox(height: 8),
            if (files.value.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: files.value
                    .map((file) => SelectedFileComponent(
                          file: file,
                          onDelete: () {
                            files.value = files.value
                                .where((f) => f.id != file.id)
                                .toList();
                          },
                        ))
                    .toList(),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No files uploaded yet',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result != null) {
                  List<File> files0 =
                      result.paths.map((path) => File(path!)).toList();
                  List<ChatFileItem> addedFiles = [];
                  for (var file in files0) {
                    final chatFile = await toChatFile(file);
                    addedFiles.add(chatFile);
                  }
                  if (addedFiles.isNotEmpty) {
                    files.value = [...files.value, ...addedFiles];
                  }
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File'),
            ),
            const SizedBox(height: 24),
            Text('Edit Custom Instructions',
                style: context.textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: customInstructionController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter custom instructions for the AI',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
