import 'dart:convert' show utf8;
import 'dart:io';

import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/src/rust/api/tool.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
  "json",
  "yaml",
  "yml",
  "toml",
  "xml",
  "svg",
  "md",
  "markdown",
  "rst",
  "txt",
  "log",
  "conf",
  "ini",
  "cfg",
  "properties",
  "env",
  "gitignore",
  "npmignore",
  "yarnignore",
};

String? customMimeType(String p) {
  final extb = path.extension(p);
  if (extb.isEmpty) {
    return null;
  }
  final ext = extb.substring(1);

  final mimeType =
      sourceCodeExtension.contains(ext) ? 'text/plain' : lookupMimeType(p);
  return mimeType;
}

Future<ChatFileItem> toChatFile(File file) async {
  final mimeType = customMimeType(file.path) ?? 'application/binary';
  final name = path.basename(file.path);
  final data = await file.readAsBytes();
  final id = await saveFile(name, mimeType, data);
  return ChatFileItem(id: id, name: name, mimeType: mimeType);
}

Future<ChatFileItem> dirToChatFile(String dir) async {
  const mimeType = 'directory';
  final name = path.basename(dir);
  final data = utf8.encode(dir);
  final id = await saveFile(name, mimeType, data);
  return ChatFileItem(id: id, name: name, mimeType: mimeType);
}

const ignoreFile = '.projectignore';
Future<List<Part>> dirToChatPart(Directory dir) async {
  if (!await dir.exists()) {
    return [];
  }
  final files = await listNonIgnoredFiles(dir: dir.path);
  final parts = <Part>[
    TextPart('Directory: ${path.basename(dir.path)}'),
  ];
  for (var file in files) {
    final relativePath = path.relative(file, from: dir.path);
    final filePart = await toChatPart(File(file), relativePath);
    parts.addAll(filePart);
  }
  parts.add(TextPart('End of directory'));
  return parts;
}

Future<List<Part>> toChatPart(File file, String name) async {
  final mimeType = customMimeType(file.path);
  if (mimeType == null) {
    return [];
  }
  final data = await file.readAsBytes();
  final parts = <Part>[
    TextPart('Attachment: $name'),
    DataPart(mimeType, data),
  ];
  return parts;
}
