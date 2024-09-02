// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeminiModelImpl _$$GeminiModelImplFromJson(Map<String, dynamic> json) =>
    _$GeminiModelImpl(
      model: json['model'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$GeminiModelImplToJson(_$GeminiModelImpl instance) =>
    <String, dynamic>{
      'model': instance.model,
      'title': instance.title,
    };

_$ModelsDataImpl _$$ModelsDataImplFromJson(Map<String, dynamic> json) =>
    _$ModelsDataImpl(
      models: (json['models'] as List<dynamic>)
          .map((e) => GeminiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdate: json['lastUpdate'] as String,
    );

Map<String, dynamic> _$$ModelsDataImplToJson(_$ModelsDataImpl instance) =>
    <String, dynamic>{
      'models': instance.models,
      'lastUpdate': instance.lastUpdate,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$chatInstructionHash() => r'0c356568d70809a9aac96442b07c3904b3ef2c76';

/// See also [ChatInstruction].
@ProviderFor(ChatInstruction)
final chatInstructionProvider =
    AutoDisposeAsyncNotifierProvider<ChatInstruction, String>.internal(
  ChatInstruction.new,
  name: r'chatInstructionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatInstructionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatInstruction = AutoDisposeAsyncNotifier<String>;
String _$modelsHash() => r'c08b6db51be24183d387ca0b41e6c861117760dd';

/// See also [Models].
@ProviderFor(Models)
final modelsProvider =
    AutoDisposeNotifierProvider<Models, List<GeminiModel>>.internal(
  Models.new,
  name: r'modelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$modelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Models = AutoDisposeNotifier<List<GeminiModel>>;
String _$selectedModelHash() => r'8452eb9132a6c1199077aca61226f9b06e06bf3d';

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
String _$generateWorkerHash() => r'c48a1d996fb20960d2e04dd41eb5ddcde7e696b8';

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
