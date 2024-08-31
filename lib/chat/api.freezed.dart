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

/// @nodoc
mixin _$GeminiModel {
  String get model => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

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

class _$GeminiModelImpl implements _GeminiModel {
  const _$GeminiModelImpl({required this.model, required this.title});

  @override
  final String model;
  @override
  final String title;

  @override
  String toString() {
    return 'GeminiModel(model: $model, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeminiModelImpl &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model, title);

  /// Create a copy of GeminiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeminiModelImplCopyWith<_$GeminiModelImpl> get copyWith =>
      __$$GeminiModelImplCopyWithImpl<_$GeminiModelImpl>(this, _$identity);
}

abstract class _GeminiModel implements GeminiModel {
  const factory _GeminiModel(
      {required final String model,
      required final String title}) = _$GeminiModelImpl;

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
