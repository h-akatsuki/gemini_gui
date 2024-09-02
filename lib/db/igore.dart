import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

const ignoreFileName = '.projectignore';

class IgnoreFilter {
  final Directory root;
  final List<_IgnoreRule> _rules = [];
  bool caseInsensitive = false;

  IgnoreFilter(this.root);

  Future<void> initialize() async {
    await _loadIgnoreRules(root);
  }

  Future<void> _loadIgnoreRules(Directory dir) async {
    final ignoreFile = File(path.join(dir.path, ignoreFileName));
    if (await ignoreFile.exists()) {
      final lines = await ignoreFile.readAsLines();
      for (var line in lines) {
        _addRule(line, dir.path);
      }
    }

    await for (var entity in dir.list()) {
      if (entity is Directory) {
        await _loadIgnoreRules(entity);
      }
    }
  }

  void _addRule(String pattern, String basePath) {
    pattern = pattern.trim();
    if (pattern.isEmpty || pattern.startsWith('#')) return;

    final rule = _IgnoreRule(pattern, basePath);
    _rules.add(rule);
  }

  Stream<FileSystemEntity> filter() async* {
    await for (var entity in root.list(recursive: true, followLinks: false)) {
      if (entity is Directory) {
        continue;
      }
      if (!shouldIgnore(entity)) {
        yield entity;
      }
    }
  }

  bool shouldIgnore(FileSystemEntity entity) {
    final relativePath = path.relative(entity.path, from: root.path);
    final isDirectory = entity is Directory;

    for (var rule in _rules.reversed) {
      final match = rule.matches(relativePath, isDirectory);
      if (match != null) {
        return match;
      }
    }

    return false;
  }

  void setCaseInsensitive(bool value) {
    caseInsensitive = value;
  }
}

class _IgnoreRule {
  final String pattern;
  final String basePath;
  final RegExp? _regex;
  final bool _isNegation;
  final bool _isDirectory;

  _IgnoreRule(String pattern, this.basePath)
      : _isNegation = pattern.startsWith('!'),
        _isDirectory = pattern.endsWith('/'),
        pattern = _normalizePattern(pattern),
        _regex = _compileRegex(_normalizePattern(pattern));

  static String _normalizePattern(String pattern) {
    pattern = pattern.replaceAll(r'\/', '/');
    if (pattern.startsWith('!')) {
      pattern = pattern.substring(1);
    }
    if (pattern.startsWith('/')) {
      pattern = pattern.substring(1);
    }
    if (pattern.endsWith('/')) {
      pattern = pattern.substring(0, pattern.length - 1);
    }
    return pattern;
  }

  static RegExp? _compileRegex(String pattern) {
    final regexPattern = pattern
        .replaceAll('.', r'\.')
        .replaceAll('*', '[^/]*')
        .replaceAll('?', '[^/]')
        .replaceAll(r'[\^]', '^')
        .replaceAll(r'[$]', r'\$')
        .replaceAll('{', '(')
        .replaceAll('}', ')')
        .replaceAll(',', '|');

    return RegExp('^$regexPattern${pattern.endsWith('/') ? '(/.*)?' : ''}');
  }

  bool? matches(String path, bool isDirectory) {
    if (_regex == null) return null;

    if (_isDirectory && !isDirectory) return null;

    final fullPath = '$basePath/$path';
    if (_regex.hasMatch(fullPath)) {
      return !_isNegation;
    }

    return null;
  }
}
