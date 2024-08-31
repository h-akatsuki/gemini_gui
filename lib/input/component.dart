import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemini_gui/suger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatInput extends HookConsumerWidget {
  const ChatInput({
    super.key,
    required this.onCamera,
    required this.onPhotoSelect,
    required this.onFileAttach,
    required this.onSubmit,
  });

  final VoidCallback onCamera;
  final VoidCallback onPhotoSelect;
  final VoidCallback onFileAttach;
  final Function(String value) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final textController = useTextEditingController();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    useEffect(() {
      void listener() {
        if (focusNode.hasFocus) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    void handleSubmit() {
      final trimmed = textController.text.trim();
      if (trimmed.isNotEmpty) {
        onSubmit(trimmed);
        textController.clear();
        focusNode.unfocus();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 120 - 80 * animationController.value,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              if (animationController.value != 0)
                                AnimatedOpacity(
                                  opacity: animationController.value,
                                  duration: const Duration(milliseconds: 150),
                                  child: ExpandedButton(onTap: () {
                                    focusNode.unfocus();
                                  }),
                                ),
                              if (animationController.value != 1)
                                OverflowBox(
                                  maxWidth: 120,
                                  fit: OverflowBoxFit.deferToChild,
                                  child: AnimatedOpacity(
                                    opacity: 1 - animationController.value,
                                    duration: const Duration(milliseconds: 150),
                                    child: ActionButtons(
                                      onCamera: onCamera,
                                      onPhotoSelect: onPhotoSelect,
                                      onFileAttach: onFileAttach,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withOpacity(0.3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: handleSubmit,
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedButton extends StatelessWidget {
  const ExpandedButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colorScheme.primaryContainer,
      ),
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: onTap,
        color: context.colorScheme.onPrimaryContainer,
        style: IconButton.styleFrom(
          foregroundColor: context.colorScheme.onPrimaryContainer,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.onCamera,
    required this.onPhotoSelect,
    required this.onFileAttach,
  });

  final VoidCallback onCamera;
  final VoidCallback onPhotoSelect;
  final VoidCallback onFileAttach;

  @override
  Widget build(BuildContext context) {
    const size = 40.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: onCamera,
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: IconButton(
            icon: const Icon(Icons.photo),
            onPressed: onPhotoSelect,
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: onFileAttach,
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
