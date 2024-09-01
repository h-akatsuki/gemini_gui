import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data.freezed.dart';
part 'data.g.dart';

@freezed
class ProjectData with _$ProjectData {
  const factory ProjectData({
    required String customInstruction,
    required List<ChatFileItem> files,
  }) = _ProjectData;

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);
}

@freezed
class ProjectInfo with _$ProjectInfo {
  const factory ProjectInfo({
    required int id,
    required String title,
    required DateTime lastUpdate,
  }) = _ProjectInfo;

  factory ProjectInfo.fromJson(Map<String, dynamic> json) =>
      _$ProjectInfoFromJson(json);
}

@Riverpod(keepAlive: true)
class ProjectList extends _$ProjectList {
  @override
  List<ProjectInfo> build() {
    Future(load);
    return [];
  }

  Future<void> load() async {
    final data = await db.rawQuery(
        'SELECT id, title, lastUpdate FROM project ORDER BY lastUpdate DESC');
    final res = <ProjectInfo>[];
    for (final item in data) {
      res.add(ProjectInfo(
        id: item['id'] as int,
        title: item['title'] as String,
        lastUpdate:
            DateTime.fromMillisecondsSinceEpoch(item['lastUpdate'] as int),
      ));
    }
    state = res;
  }

  Future<void> add(String title, ProjectData data) async {
    final id = await saveProject(title, jsonEncode(data.toJson()));
    state = [
      ...state,
      ProjectInfo(id: id, title: title, lastUpdate: DateTime.now())
    ];
  }

  Future<void> remove(int id) async {
    state = state.where((e) => e.id != id).toList();
    await deleteProject(id);
  }

  Future<void> update(int id, {String? title, ProjectData? data}) async {
    final newItem = state.firstWhere((e) => e.id == id);
    final newTitle = title ?? newItem.title;
    if (data == null) {
      await updateProjectTitle(id, newTitle);
    } else {
      await updateProject(id, newTitle, jsonEncode(data.toJson()));
    }
    final newState = state.map((e) {
      if (e.id == id) {
        return ProjectInfo(id: id, title: newTitle, lastUpdate: DateTime.now());
      }
      return e;
    }).toList();
    newState.sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
    state = newState;
  }
}

@Riverpod(keepAlive: true)
class SelectedProject extends _$SelectedProject {
  @override
  int? build() {
    ref.listen(projectListProvider, (v1, v2) {
      if (state == null || v1 == null) {
        return;
      }
      final has = v2.any((e) => e.id == state);
      if (!has) {
        clear();
      }
    });
    return null;
  }

  void select(int id) {
    if (state != id) {
      state = id;
      ref.read(chatHistoryProvider.notifier).clear();
    }
  }

  void clear() {
    state = null;
    ref.read(chatHistoryProvider.notifier).clear();
  }
}
