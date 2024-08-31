// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generativeModelHash() => r'1240f5f04ee8ebd56659fa3d628cc0c27108de94';

/// See also [generativeModel].
@ProviderFor(generativeModel)
final generativeModelProvider = AutoDisposeProvider<GenerativeModel>.internal(
  generativeModel,
  name: r'generativeModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generativeModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GenerativeModelRef = AutoDisposeProviderRef<GenerativeModel>;
String _$apiKeyHash() => r'eef6b4aaa3dd5828b49ac525c005337f17b1f3c3';

/// See also [ApiKey].
@ProviderFor(ApiKey)
final apiKeyProvider = AutoDisposeNotifierProvider<ApiKey, String?>.internal(
  ApiKey.new,
  name: r'apiKeyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApiKey = AutoDisposeNotifier<String?>;
String _$selectedModelHash() => r'684b999ab5a98f765e4a940a52ad7f9b2e80012a';

/// See also [SelectedModel].
@ProviderFor(SelectedModel)
final selectedModelProvider =
    AutoDisposeNotifierProvider<SelectedModel, GeminiModel>.internal(
  SelectedModel.new,
  name: r'selectedModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedModel = AutoDisposeNotifier<GeminiModel>;
String _$generatingResponseHash() =>
    r'96aee07944fc8b7305e593dd29dcca48ed15ae06';

/// See also [GeneratingResponse].
@ProviderFor(GeneratingResponse)
final generatingResponseProvider =
    NotifierProvider<GeneratingResponse, bool>.internal(
  GeneratingResponse.new,
  name: r'generatingResponseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generatingResponseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GeneratingResponse = Notifier<bool>;
String _$generateWorkerHash() => r'dd91979f196e66f2868aca007060df0411cf6625';

/// See also [GenerateWorker].
@ProviderFor(GenerateWorker)
final generateWorkerProvider =
    NotifierProvider<GenerateWorker, WorkerState>.internal(
  GenerateWorker.new,
  name: r'generateWorkerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generateWorkerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GenerateWorker = Notifier<WorkerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
