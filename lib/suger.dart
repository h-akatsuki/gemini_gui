import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (context) => page));
  }

  void pop() {
    Navigator.of(this).pop();
  }
}
