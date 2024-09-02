import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemini_gui/chat/files.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late List<CameraDescription> _cameras;

Future<void> initCameras() async {
  if (!(Platform.isAndroid || Platform.isIOS)) {
    return;
  }
  _cameras = await availableCameras();
}

class CameraPage extends HookConsumerWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useMemoized(() => CameraController(_cameras[0], ResolutionPreset.max));
    final isInitialized = useState(false);

    useEffect(() {
      controller.initialize().then((_) {
        isInitialized.value = true;
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              debugPrint(
                  'Error: The user did not grant the camera permission!');
              if (context.mounted) Navigator.of(context).pop();
              break;
            default:
              debugPrint('Error: $e');
              if (context.mounted) Navigator.of(context).pop();
              break;
          }
        }
      });
      return controller.dispose;
    }, [controller]);

    if (!isInitialized.value) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Future<void> takePicture(
        BuildContext context, CameraController controller) async {
      try {
        final image = await controller.takePicture();
        final data = await image.readAsBytes();
        final mimeType = image.mimeType ?? 'image/jpeg';
        final name = image.path.split('/').last;
        final id = await saveFile(name, mimeType, data);
        final file = ChatFileItem(id: id, name: name, mimeType: mimeType);
        ref.read(chatInputFilesProvider.notifier).add(file);
        if (context.mounted) Navigator.of(context).pop(id);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to capture image: $e')),
          );
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CameraPreview(controller),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: context.colorScheme.onSurface),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton(
                        child: const Icon(Icons.camera),
                        onPressed: () => takePicture(context, controller),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
