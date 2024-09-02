// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GeminiModel _$GeminiModelFromJson(Map<String, dynamic> json) {
  return _GeminiModel.fromJson(json);
}

/// @nodoc
mixin _$GeminiModel {
  String get model => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  /// Serializes this GeminiModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeminiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeminiModelCopyWith<GeminiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeminiModelCopyWith<$Res> {
  factory $GeminiModelCopyWith(
          GeminiModel value, $Res Function(GeminiModel) then) =
      _$GeminiModelCopyWithImpl<$Res, GeminiModel>;
  @useResult
  $Res call({String model, String title});
}

/// @nodoc
class _$GeminiModelCopyWithImpl<$Res, $Val extends GeminiModel>
    implements $GeminiModelCopyWith<$Res> {
  _$GeminiModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeminiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? title = null,
  }) {
    return _then(_value.copyWith(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeminiModelImplCopyWith<$Res>
    implements $GeminiModelCopyWith<$Res> {
  factory _$$GeminiModelImplCopyWith(
          _$GeminiModelImpl value, $Res Function(_$GeminiModelImpl) then) =
      __$$GeminiModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String model, String title});
}

/// @nodoc
class __$$GeminiModelImplCopyWithImpl<$Res>
    extends _$GeminiModelCopyWithImpl<$Res, _$GeminiModelImpl>
    implements _$$GeminiModelImplCopyWith<$Res> {
  __$$GeminiModelImplCopyWithImpl(
      _$GeminiModelImpl _value, $Res Function(_$GeminiModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeminiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? title = null,
  }) {
    return _then(_$GeminiModelImpl(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeminiModelImpl with DiagnosticableTreeMixin implements _GeminiModel {
  const _$GeminiModelImpl({required this.model, required this.title});

  factory _$GeminiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeminiModelImplFromJson(json);

  @override
  final String model;
  @override
  final String title;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GeminiModel(model: $model, title: $title)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GeminiModel'))
      ..add(DiagnosticsProperty('model', model))
      ..add(DiagnosticsProperty('title', title));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeminiModelImpl &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, model, title);

  /// Create a copy of GeminiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeminiModelImplCopyWith<_$GeminiModelImpl> get copyWith =>
      __$$GeminiModelImplCopyWithImpl<_$GeminiModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeminiModelImplToJson(
      this,
    );
  }
}

abstract class _GeminiModel implements GeminiModel {
  const factory _GeminiModel(
      {required final String model,
      required final String title}) = _$GeminiModelImpl;

  factory _GeminiModel.fromJson(Map<String, dynamic> json) =
      _$GeminiModelImpl.fromJson;

  @override
  String get model;
  @override
  String get title;

  /// Create a copy of GeminiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeminiModelImplCopyWith<_$GeminiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ModelsData _$ModelsDataFromJson(Map<String, dynamic> json) {
  return _ModelsData.fromJson(json);
}

/// @nodoc
mixin _$ModelsData {
  List<GeminiModel> get models => throw _privateConstructorUsedError;
  String get lastUpdate => throw _privateConstructorUsedError;

  /// Serializes this ModelsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelsDataCopyWith<ModelsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelsDataCopyWith<$Res> {
  factory $ModelsDataCopyWith(
          ModelsData value, $Res Function(ModelsData) then) =
      _$ModelsDataCopyWithImpl<$Res, ModelsData>;
  @useResult
  $Res call({List<GeminiModel> models, String lastUpdate});
}

/// @nodoc
class _$ModelsDataCopyWithImpl<$Res, $Val extends ModelsData>
    implements $ModelsDataCopyWith<$Res> {
  _$ModelsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
    Object? lastUpdate = null,
  }) {
    return _then(_value.copyWith(
      models: null == models
          ? _value.models
          : models // ignore: cast_nullable_to_non_nullable
              as List<GeminiModel>,
      lastUpdate: null == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModelsDataImplCopyWith<$Res>
    implements $ModelsDataCopyWith<$Res> {
  factory _$$ModelsDataImplCopyWith(
          _$ModelsDataImpl value, $Res Function(_$ModelsDataImpl) then) =
      __$$ModelsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GeminiModel> models, String lastUpdate});
}

/// @nodoc
class __$$ModelsDataImplCopyWithImpl<$Res>
    extends _$ModelsDataCopyWithImpl<$Res, _$ModelsDataImpl>
    implements _$$ModelsDataImplCopyWith<$Res> {
  __$$ModelsDataImplCopyWithImpl(
      _$ModelsDataImpl _value, $Res Function(_$ModelsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModelsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
    Object? lastUpdate = null,
  }) {
    return _then(_$ModelsDataImpl(
      models: null == models
          ? _value._models
          : models // ignore: cast_nullable_to_non_nullable
              as List<GeminiModel>,
      lastUpdate: null == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelsDataImpl with DiagnosticableTreeMixin implements _ModelsData {
  const _$ModelsDataImpl(
      {required final List<GeminiModel> models, required this.lastUpdate})
      : _models = models;

  factory _$ModelsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelsDataImplFromJson(json);

  final List<GeminiModel> _models;
  @override
  List<GeminiModel> get models {
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_models);
  }

  @override
  final String lastUpdate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ModelsData(models: $models, lastUpdate: $lastUpdate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ModelsData'))
      ..add(DiagnosticsProperty('models', models))
      ..add(DiagnosticsProperty('lastUpdate', lastUpdate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelsDataImpl &&
            const DeepCollectionEquality().equals(other._models, _models) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_models), lastUpdate);

  /// Create a copy of ModelsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelsDataImplCopyWith<_$ModelsDataImpl> get copyWith =>
      __$$ModelsDataImplCopyWithImpl<_$ModelsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelsDataImplToJson(
      this,
    );
  }
}

abstract class _ModelsData implements ModelsData {
  const factory _ModelsData(
      {required final List<GeminiModel> models,
      required final String lastUpdate}) = _$ModelsDataImpl;

  factory _ModelsData.fromJson(Map<String, dynamic> json) =
      _$ModelsDataImpl.fromJson;

  @override
  List<GeminiModel> get models;
  @override
  String get lastUpdate;

  /// Create a copy of ModelsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelsDataImplCopyWith<_$ModelsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
