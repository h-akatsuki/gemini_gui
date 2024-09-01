import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gemini_gui/db/db.dart';

part 'history.freezed.dart';

@freezed
class ChatLogItem with _$ChatLogItem {
  const factory ChatLogItem({
    required int id,
    required String title,
  }) = _ChatLogItem;
}

class ChatLogManager {
  static const capacity = 50;
  static const logCount = 3;
  final List<List<ChatLogItem?>?> _logs =
      List.filled(capacity, null, growable: false);
  final List<int?> _indexes = List.filled(logCount, null, growable: false);
  int _index = 0;
  Future<ChatLogItem?>? _lock;

  final int? projectId;

  ChatLogManager({this.projectId});

  Future<int> length() async {
    if (projectId == null) {
      final res = await db.rawQuery('''
        SELECT COUNT(*) FROM chat WHERE projectId IS NULL
      ''');
      return res.first.values.first as int;
    }
    final res = await db.rawQuery('''
      SELECT COUNT(*) FROM chat WHERE projectId = ?
    ''', [projectId]);
    return res.first.values.first as int;
  }

  Future<ChatLogItem?> load(int index) async {
    while (_lock != null) {
      await _lock;
    }
    _lock = _load(index);
    final res = await _lock;
    _lock = null;
    return res;
  }

  Future<ChatLogItem?> _load(int index) async {
    if (index < 0) {
      return null;
    }
    for (var i = 0; i < logCount; i++) {
      final start = _indexes[i];
      if (start == null) {
        continue;
      }
      if (start <= index && index < start + capacity) {
        final logs = _logs[i];
        if (logs == null) {
          return null;
        }
        return logs[index - start];
      }
    }
    final List<Map<String, Object?>> res;
    if (projectId == null) {
      res = await db.rawQuery('''
      SELECT id, title FROM chat WHERE projectId IS NULL ORDER BY lastUpdate DESC LIMIT $capacity OFFSET $index
    ''');
    } else {
      res = await db.rawQuery('''
      SELECT id, title FROM chat WHERE projectId = ? ORDER BY lastUpdate DESC LIMIT $capacity OFFSET $index
    ''', [projectId]);
    }
    final List<ChatLogItem?> logs =
        List.filled(capacity, null, growable: false);
    for (var i = 0; i < res.length; i++) {
      logs[i] = ChatLogItem(
        id: res[i]['id'] as int,
        title: res[i]['title'] as String,
      );
    }
    _logs[_index] = logs;
    _indexes[_index] = index;
    _index = (_index + 1) % logCount;
    return logs[0];
  }
}
