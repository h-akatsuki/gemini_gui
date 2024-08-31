import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_gui/camera/page.dart';
import 'package:gemini_gui/chat/api.dart';
import 'package:gemini_gui/chat/component.dart';
import 'package:gemini_gui/chat/files.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/drawer.dart/widget.dart';
import 'package:gemini_gui/home/component.dart';
import 'package:gemini_gui/input/component.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ChatAppDrawer(),
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
            const Expanded(
              child: Messages(),
            ),
            const ChatInputFileView(),
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
              onFileAttach: () {},
              onPhotoSelect: () {},
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
