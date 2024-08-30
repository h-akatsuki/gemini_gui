import 'package:flutter/material.dart';
import 'package:gemini_gui/home/component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Expanded(child: Center(child: Text('Hello, World!'))),
              ChatInput(
                onCamera: () {},
                onFileAttach: () {},
                onPhotoSelect: () {},
                onSubmit: (p0) {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
