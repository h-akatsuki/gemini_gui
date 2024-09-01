import 'dart:io';

import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

final sourceCodeExtension = {
  "c",
  "h",
  "cpp",
  "hpp",
  "java",
  "kt",
  "py",
  "js",
  "mjs",
  "cjs",
  "ts",
  "mts",
  "cts",
  "tsx",
  "jsx",
  "html",
  "css",
  "scss",
  "sass",
  "less",
  "rb",
  "php",
  "phtml",
  "php3",
  "php4",
  "php5",
  "php7",
  "php8",
  "phps",
  "cs",
  "rs",
  "go",
  "swift",
  "dart",
  "sh",
  "bash",
  "zsh",
  "fish",
  "ps1",
  "psm1",
  "bat",
  "cmd",
  "vbs",
  "lua",
  "pl",
  "r",
  "sql",
};

Future<ChatFileItem> toChatFile(File file) async {
  final mimeType =
      sourceCodeExtension.contains(path.extension(file.path).substring(1))
          ? 'text/plain'
          : lookupMimeType(file.path) ?? 'application/binary';
  final name = path.basename(file.path);
  final data = await file.readAsBytes();
  final id = await saveFile(name, mimeType, data);
  return ChatFileItem(id: id, name: name, mimeType: mimeType);
}
