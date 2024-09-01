// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectData _$ProjectDataFromJson(Map<String, dynamic> json) {
  return _ProjectData.fromJson(json);
}

/// @nodoc
mixin _$ProjectData {
  String get customInstruction => throw _privateConstructorUsedError;
  List<ChatFileItem> get files => throw _privateConstructorUsedError;

  /// Serializes this ProjectData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectDataCopyWith<ProjectData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectDataCopyWith<$Res> {
  factory $ProjectDataCopyWith(
          ProjectData value, $Res Function(ProjectData) then) =
      _$ProjectDataCopyWithImpl<$Res, ProjectData>;
  @useResult
  $Res call({String customInstruction, List<ChatFileItem> files});
}

/// @nodoc
class _$ProjectDataCopyWithImpl<$Res, $Val extends ProjectData>
    implements $ProjectDataCopyWith<$Res> {
  _$ProjectDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customInstruction = null,
    Object? files = null,
  }) {
    return _then(_value.copyWith(
      customInstruction: null == customInstruction
          ? _value.customInstruction
          : customInstruction // ignore: cast_nullable_to_non_nullable
              as String,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<ChatFileItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectDataImplCopyWith<$Res>
    implements $ProjectDataCopyWith<$Res> {
  factory _$$ProjectDataImplCopyWith(
          _$ProjectDataImpl value, $Res Function(_$ProjectDataImpl) then) =
      __$$ProjectDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String customInstruction, List<ChatFileItem> files});
}

/// @nodoc
class __$$ProjectDataImplCopyWithImpl<$Res>
    extends _$ProjectDataCopyWithImpl<$Res, _$ProjectDataImpl>
    implements _$$ProjectDataImplCopyWith<$Res> {
  __$$ProjectDataImplCopyWithImpl(
      _$ProjectDataImpl _value, $Res Function(_$ProjectDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customInstruction = null,
    Object? files = null,
  }) {
    return _then(_$ProjectDataImpl(
      customInstruction: null == customInstruction
          ? _value.customInstruction
          : customInstruction // ignore: cast_nullable_to_non_nullable
              as String,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<ChatFileItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectDataImpl implements _ProjectData {
  const _$ProjectDataImpl(
      {required this.customInstruction,
      required final List<ChatFileItem> files})
      : _files = files;

  factory _$ProjectDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectDataImplFromJson(json);

  @override
  final String customInstruction;
  final List<ChatFileItem> _files;
  @override
  List<ChatFileItem> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'ProjectData(customInstruction: $customInstruction, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectDataImpl &&
            (identical(other.customInstruction, customInstruction) ||
                other.customInstruction == customInstruction) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, customInstruction,
      const DeepCollectionEquality().hash(_files));

  /// Create a copy of ProjectData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectDataImplCopyWith<_$ProjectDataImpl> get copyWith =>
      __$$ProjectDataImplCopyWithImpl<_$ProjectDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectDataImplToJson(
      this,
    );
  }
}

abstract class _ProjectData implements ProjectData {
  const factory _ProjectData(
      {required final String customInstruction,
      required final List<ChatFileItem> files}) = _$ProjectDataImpl;

  factory _ProjectData.fromJson(Map<String, dynamic> json) =
      _$ProjectDataImpl.fromJson;

  @override
  String get customInstruction;
  @override
  List<ChatFileItem> get files;

  /// Create a copy of ProjectData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectDataImplCopyWith<_$ProjectDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectInfo _$ProjectInfoFromJson(Map<String, dynamic> json) {
  return _ProjectInfo.fromJson(json);
}

/// @nodoc
mixin _$ProjectInfo {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get lastUpdate => throw _privateConstructorUsedError;

  /// Serializes this ProjectInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectInfoCopyWith<ProjectInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectInfoCopyWith<$Res> {
  factory $ProjectInfoCopyWith(
          ProjectInfo value, $Res Function(ProjectInfo) then) =
      _$ProjectInfoCopyWithImpl<$Res, ProjectInfo>;
  @useResult
  $Res call({int id, String title, DateTime lastUpdate});
}

/// @nodoc
class _$ProjectInfoCopyWithImpl<$Res, $Val extends ProjectInfo>
    implements $ProjectInfoCopyWith<$Res> {
  _$ProjectInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lastUpdate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdate: null == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectInfoImplCopyWith<$Res>
    implements $ProjectInfoCopyWith<$Res> {
  factory _$$ProjectInfoImplCopyWith(
          _$ProjectInfoImpl value, $Res Function(_$ProjectInfoImpl) then) =
      __$$ProjectInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, DateTime lastUpdate});
}

/// @nodoc
class __$$ProjectInfoImplCopyWithImpl<$Res>
    extends _$ProjectInfoCopyWithImpl<$Res, _$ProjectInfoImpl>
    implements _$$ProjectInfoImplCopyWith<$Res> {
  __$$ProjectInfoImplCopyWithImpl(
      _$ProjectInfoImpl _value, $Res Function(_$ProjectInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lastUpdate = null,
  }) {
    return _then(_$ProjectInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdate: null == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectInfoImpl implements _ProjectInfo {
  const _$ProjectInfoImpl(
      {required this.id, required this.title, required this.lastUpdate});

  factory _$ProjectInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final DateTime lastUpdate;

  @override
  String toString() {
    return 'ProjectInfo(id: $id, title: $title, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, lastUpdate);

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectInfoImplCopyWith<_$ProjectInfoImpl> get copyWith =>
      __$$ProjectInfoImplCopyWithImpl<_$ProjectInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectInfoImplToJson(
      this,
    );
  }
}

abstract class _ProjectInfo implements ProjectInfo {
  const factory _ProjectInfo(
      {required final int id,
      required final String title,
      required final DateTime lastUpdate}) = _$ProjectInfoImpl;

  factory _ProjectInfo.fromJson(Map<String, dynamic> json) =
      _$ProjectInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  DateTime get lastUpdate;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectInfoImplCopyWith<_$ProjectInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
