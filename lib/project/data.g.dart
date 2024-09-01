// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectDataImpl _$$ProjectDataImplFromJson(Map<String, dynamic> json) =>
    _$ProjectDataImpl(
      customInstruction: json['customInstruction'] as String,
      files: (json['files'] as List<dynamic>)
          .map((e) => ChatFileItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProjectDataImplToJson(_$ProjectDataImpl instance) =>
    <String, dynamic>{
      'customInstruction': instance.customInstruction,
      'files': instance.files,
    };

_$ProjectInfoImpl _$$ProjectInfoImplFromJson(Map<String, dynamic> json) =>
    _$ProjectInfoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$$ProjectInfoImplToJson(_$ProjectInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectListHash() => r'ad5d5be41bdbe5de267e2d468e9adbf8c5a7c099';

/// See also [ProjectList].
@ProviderFor(ProjectList)
final projectListProvider =
    NotifierProvider<ProjectList, List<ProjectInfo>>.internal(
  ProjectList.new,
  name: r'projectListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$projectListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectList = Notifier<List<ProjectInfo>>;
String _$selectedProjectHash() => r'd92a95a19455feab8b137600ad345fb6d26a2e3b';

/// See also [SelectedProject].
@ProviderFor(SelectedProject)
final selectedProjectProvider =
    NotifierProvider<SelectedProject, int?>.internal(
  SelectedProject.new,
  name: r'selectedProjectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedProjectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedProject = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
