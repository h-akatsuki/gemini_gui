// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getChatHistoryItemsHash() =>
    r'4a3badbc1def739dcf64c684ab681545a422fb55';

/// See also [getChatHistoryItems].
@ProviderFor(getChatHistoryItems)
final getChatHistoryItemsProvider =
    AutoDisposeProvider<List<ChatHistoryItem>>.internal(
  getChatHistoryItems,
  name: r'getChatHistoryItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getChatHistoryItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetChatHistoryItemsRef = AutoDisposeProviderRef<List<ChatHistoryItem>>;
String _$chatHistoryHash() => r'b2ade9ac32bc44511b7749e6c887d7c1003c830c';

/// See also [ChatHistory].
@ProviderFor(ChatHistory)
final chatHistoryProvider =
    NotifierProvider<ChatHistory, ChatHistoryRoot>.internal(
  ChatHistory.new,
  name: r'chatHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatHistory = Notifier<ChatHistoryRoot>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
