import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gemini_gui/camera/page.dart';
import 'package:gemini_gui/chat/api.dart';
import 'package:gemini_gui/chat/component.dart';
import 'package:gemini_gui/chat/files.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/file.dart';
import 'package:gemini_gui/drawer/widget.dart';
import 'package:gemini_gui/home/component.dart';
import 'package:gemini_gui/input/component.dart';
import 'package:gemini_gui/project/header.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apikey = ref.watch(apiKeyProvider.select((value) => value != null));
    if (!apikey) {
      return const APIKeyIsNotSet();
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ChatAppDrawerLock(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Column(
          children: [
            ChatAppHeader(drawerOpen: () {
              _scaffoldKey.currentState?.openDrawer();
            }),
            const ProjectHeader(),
            const Expanded(
              child: Stack(
                children: [
                  Messages(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ChatInputFileView(),
                  ),
                ],
              ),
            ),
            ChatInput(
              onCamera: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  context.push(
                    const CameraPage(),
                  );
                } else {
                  // SnackBar (not supported)
                  debugPrint('Camera is not supported');
                }
              },
              onFileAttach: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result != null) {
                  List<File> files =
                      result.paths.map((path) => File(path!)).toList();
                  for (var file in files) {
                    final chatFile = await toChatFile(file);
                    ref.read(chatInputFilesProvider.notifier).add(chatFile);
                  }
                }
              },
              onPhotoSelect: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'webp'],
                );
                if (result != null) {
                  List<File> files =
                      result.paths.map((path) => File(path!)).toList();
                  for (var file in files) {
                    final chatFile = await toChatFile(file);
                    ref.read(chatInputFilesProvider.notifier).add(chatFile);
                  }
                }
              },
              onSubmit: (p0) {
                ref.read(chatHistoryProvider.notifier).add(
                      ChatHistoryItem.user(
                        p0.replaceAll('\n', '  \n'),
                        files: ref.read(chatInputFilesProvider.notifier).take(),
                      ),
                    );
                ref.read(generateWorkerProvider.notifier).generate();
              },
            ),
          ],
        ),
      ),
    );
  }
}
