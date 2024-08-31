import 'dart:convert';

import 'package:gemini_gui/db/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

class ChatFileItem {
  final int id;
  final String name;
  final String mimeType;

  const ChatFileItem({
    required this.id,
    required this.name,
    required this.mimeType,
  });

  factory ChatFileItem.fromJson(Map<String, dynamic> json) => ChatFileItem(
        id: json['id'] as int,
        name: json['name'] as String,
        mimeType: json['mimeType'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mimeType': mimeType,
      };
}

class ChatHistoryItem {
  final String message;
  final bool isUser;
  final bool error;
  final List<ChatFileItem> files;

  const ChatHistoryItem({
    required this.message,
    required this.isUser,
    required this.error,
    required this.files,
  });

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) =>
      ChatHistoryItem(
        message: json['message'] as String,
        isUser: json['isUser'] as bool,
        error: json['error'] as bool,
        files: (json['files'] as List<dynamic>)
            .map((e) => ChatFileItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'isUser': isUser,
        'error': error,
        'files': files.map((e) => e.toJson()).toList(),
      };

  factory ChatHistoryItem.user(String message,
      {List<ChatFileItem> files = const []}) {
    return ChatHistoryItem(
      message: message,
      isUser: true,
      error: false,
      files: files,
    );
  }

  factory ChatHistoryItem.bot(String message) {
    return ChatHistoryItem(
      message: message,
      isUser: false,
      error: false,
      files: [],
    );
  }

  factory ChatHistoryItem.error(String message) {
    return ChatHistoryItem(
      message: message,
      isUser: false,
      error: true,
      files: [],
    );
  }
}

class ChatHistoryTree {
  final ChatHistoryItem item;
  final List<ChatHistoryTree> items;

  const ChatHistoryTree({
    required this.item,
    required this.items,
  });

  factory ChatHistoryTree.fromJson(Map<String, dynamic> json) =>
      ChatHistoryTree(
        item: ChatHistoryItem.fromJson(json['item'] as Map<String, dynamic>),
        items: (json['items'] as List<dynamic>)
            .map((e) => ChatHistoryTree.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'item': item.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class ChatVersion {
  final int total;
  final int current;

  const ChatVersion({
    required this.total,
    required this.current,
  });
}

class ChatHistoryRoot {
  final int? id;
  final String? title;
  final List<ChatHistoryTree> tree;
  final List<int> selected;

  const ChatHistoryRoot({
    required this.id,
    required this.title,
    required this.tree,
    required this.selected,
  });

  factory ChatHistoryRoot.fromJson(Map<String, dynamic> json) =>
      ChatHistoryRoot(
        id: json['id'] as int?,
        title: json['title'] as String?,
        tree: (json['tree'] as List<dynamic>)
            .map((e) => ChatHistoryTree.fromJson(e as Map<String, dynamic>))
            .toList(),
        selected:
            (json['selected'] as List<dynamic>).map((e) => e as int).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tree': tree.map((e) => e.toJson()).toList(),
        'selected': selected,
      };

  factory ChatHistoryRoot.empty() {
    return const ChatHistoryRoot(
      id: null,
      title: null,
      tree: [],
      selected: [],
    );
  }

  ChatHistoryRoot copyWith({
    int? id,
    String? title,
    List<int>? selected,
  }) {
    return ChatHistoryRoot(
      id: id ?? this.id,
      title: title ?? this.title,
      tree: tree,
      selected: selected ?? this.selected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatHistoryRoot &&
        other.id == id &&
        other.title == title &&
        other.selected == selected;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ selected.hashCode;

  ChatHistoryItem? getItem(int index) {
    if (index < 0 || index >= selected.length) {
      return null;
    }
    ChatHistoryTree tree = this.tree[selected[0]];
    int i = 1;
    while (i <= index) {
      tree = tree.items[selected[i]];
      i++;
    }
    return tree.item;
  }

  ChatVersion? getVersion(int index) {
    if (index < 0 || index >= selected.length) {
      return null;
    }
    if (index == 0) {
      return ChatVersion(total: this.tree.length, current: selected[0]);
    }
    ChatHistoryTree tree = this.tree[selected[0]];
    int i = 1;
    while (i < index) {
      tree = tree.items[selected[i]];
      i++;
    }
    return ChatVersion(total: tree.items.length, current: selected[index]);
  }

  int get length {
    return selected.length;
  }
}

@Riverpod(keepAlive: true)
class ChatHistory extends _$ChatHistory {
  @override
  ChatHistoryRoot build() {
    return ChatHistoryRoot.empty();
  }

  void add(ChatHistoryItem item) {
    if (state.tree.isEmpty) {
      state = ChatHistoryRoot(
        id: null,
        title: null,
        tree: [ChatHistoryTree(item: item, items: [])],
        selected: [0],
      );
    } else {
      ChatHistoryTree tree = state.tree[state.selected[0]];
      for (final index in state.selected.skip(1)) {
        tree = tree.items[index];
      }
      tree.items.add(ChatHistoryTree(item: item, items: []));
      state =
          state.copyWith(selected: [...state.selected, tree.items.length - 1]);
    }
    save();
  }

  Future<void> save() async {
    if (state.tree.isEmpty) {
      return;
    }
    if (state.id == null) {
      final title = state.title ?? state.tree[0].item.message.split('\n')[0];
      final id = await saveChat(title, jsonEncode(state.toJson()));
      state = state.copyWith(id: id);
    } else {
      final title = state.title ?? state.tree[0].item.message.split('\n')[0];
      updateChat(state.id!, title, jsonEncode(state.toJson()));
    }
  }

  Future<void> load(int id) async {
    final data = await loadChatById(id);
    if (data == null) {
      state = ChatHistoryRoot.empty();
    } else {
      state = ChatHistoryRoot.fromJson(jsonDecode(data));
    }
  }

  Future<void> clear() async {
    state = ChatHistoryRoot.empty();
  }

  void pop() {
    if (state.selected.isEmpty) {
      return;
    }
    state = state.copyWith(
        selected: state.selected.sublist(0, state.selected.length - 1));
  }

  void setlength(int length) {
    if (state.selected.length == length) {
      return;
    }
    state = state.copyWith(selected: state.selected.sublist(0, length));
  }

  void swich(int index, int version) {
    if (state.selected.isEmpty) {
      return;
    }
    final newSelected = state.selected.sublist(0, index);
    newSelected.add(version);
    ChatHistoryTree tree = state.tree[newSelected[0]];
    for (final index in newSelected.skip(1)) {
      tree = tree.items[index];
    }
    while (tree.items.isNotEmpty) {
      newSelected.add(tree.items.length - 1);
      tree = tree.items[tree.items.length - 1];
    }
    state = state.copyWith(selected: newSelected);
  }
}

@riverpod
List<ChatHistoryItem> getChatHistoryItems(GetChatHistoryItemsRef ref) {
  final root = ref.watch(chatHistoryProvider);
  if (root.selected.isEmpty) {
    return [];
  }
  ChatHistoryTree tree = root.tree[root.selected[0]];
  final items = <ChatHistoryItem>[tree.item];
  for (final index in root.selected.skip(1)) {
    tree = tree.items[index];
    items.add(tree.item);
  }
  return items;
}
