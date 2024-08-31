import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late final Directory appDocDir;
late final Database db;

Future<void> initPath() async {
  if (kDebugMode && Platform.isWindows) {
    appDocDir = Directory('data');
  } else {
    if (Platform.isWindows) {
      // Portable mode
      final saveDir = Directory('save');
      if (await saveDir.exists()) {
        appDocDir = saveDir;
      } else {
        appDocDir = await getApplicationDocumentsDirectory();
      }
    } else {
      appDocDir = await getApplicationDocumentsDirectory();
    }
  }
}

Future<void> initDb() async {
  sqfliteFfiInit();
  db = await databaseFactoryFfi.openDatabase(
    join(appDocDir.absolute.path, 'data.db'),
  );
  await db.transaction((txn) async {
    await txn.execute('''
    CREATE TABLE IF NOT EXISTS kv (
      key TEXT PRIMARY KEY,
      value TEXT
    )
  ''');
    await txn.execute('''
    CREATE TABLE IF NOT EXISTS chat (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt INTEGER,
      lastUpdate INTEGER,
      title TEXT,
      data TEXT
    )
  ''');
    await txn.execute(
        "CREATE INDEX IF NOT EXISTS chat_lastUpdate ON chat (lastUpdate)");
    await txn.execute('''
    CREATE TABLE IF NOT EXISTS chatFile (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      mimeType TEXT,
      data BLOB
    )
  ''');
  });
}

Future<void> setKV(String key, String value) async {
  await db.rawInsert('''
    INSERT OR REPLACE INTO kv (key, value) VALUES (?, ?)
  ''', [key, value]);
}

Future<String?> getKV(String key) async {
  final res = await db.rawQuery('''
    SELECT value FROM kv WHERE key = ?
  ''', [key]);
  if (res.isEmpty) {
    return null;
  } else {
    return res.first['value'] as String;
  }
}

Future<void> deleteKV(String key) async {
  await db.rawDelete('''
    DELETE FROM kv WHERE key = ?
  ''', [key]);
}

Future<void> setKVBool(String key, bool value) async {
  await setKV(key, value ? 't' : 'f');
}

Future<bool?> getKVBool(String key) async {
  final res = await getKV(key);
  if (res == null) {
    return null;
  } else {
    return res == 't';
  }
}

Future<void> setKVInt(String key, int value) async {
  await setKV(key, value.toString());
}

Future<int?> getKVInt(String key) async {
  final res = await getKV(key);
  if (res == null) {
    return null;
  } else {
    return int.parse(res);
  }
}

Future<int> saveFile(String name, String mimeType, Uint8List data) async {
  final res = await db.rawInsert('''
    INSERT INTO chatFile (name, mimeType, data) VALUES (?, ?, ?)
  ''', [name, mimeType, data]);
  return res;
}

Future<Uint8List?> loadFile(int id) async {
  final res = await db.rawQuery('''
    SELECT data FROM chatFile WHERE id = ?
  ''', [id]);
  if (res.isEmpty) {
    return null;
  } else {
    return res.first['data'] as Uint8List;
  }
}

Future<String?> loadChat() async {
  final res = await db.rawQuery('''
    SELECT data FROM chat ORDER BY lastUpdate DESC LIMIT 1
  ''');
  if (res.isEmpty) {
    return null;
  } else {
    return res.first['data'] as String;
  }
}

Future<int> saveChat(String title, String data) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  final res = await db.rawInsert('''
    INSERT INTO chat (createdAt, lastUpdate, title, data) VALUES (?, ?, ?, ?)
  ''', [now, now, title, data]);
  return res;
}

Future<void> updateChat(int id, String title, String data) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.rawUpdate('''
    UPDATE chat SET lastUpdate = ?, title = ?, data = ? WHERE id = ?
  ''', [now, title, data, id]);
}

Future<void> deleteChat(int id) async {
  await db.rawDelete('''
    DELETE FROM chat WHERE id = ?
  ''', [id]);
}

Future<String?> loadChatById(int id) async {
  final res = await db.rawQuery('''
    SELECT data FROM chat WHERE id = ?
  ''', [id]);
  if (res.isEmpty) {
    return null;
  } else {
    return res.first['data'] as String;
  }
}
