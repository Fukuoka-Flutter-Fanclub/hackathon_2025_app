// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'koemyaku_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KoemyakuData {

 String get id; String get userId; String get title; String get message;@TimestampConverter() DateTime get createdAt;@NullableTimestampConverter() DateTime? get updatedAt; List<MarkerData> get markers;
/// Create a copy of KoemyakuData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KoemyakuDataCopyWith<KoemyakuData> get copyWith => _$KoemyakuDataCopyWithImpl<KoemyakuData>(this as KoemyakuData, _$identity);

  /// Serializes this KoemyakuData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KoemyakuData&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.markers, markers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,message,createdAt,updatedAt,const DeepCollectionEquality().hash(markers));

@override
String toString() {
  return 'KoemyakuData(id: $id, userId: $userId, title: $title, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, markers: $markers)';
}


}

/// @nodoc
abstract mixin class $KoemyakuDataCopyWith<$Res>  {
  factory $KoemyakuDataCopyWith(KoemyakuData value, $Res Function(KoemyakuData) _then) = _$KoemyakuDataCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String message,@TimestampConverter() DateTime createdAt,@NullableTimestampConverter() DateTime? updatedAt, List<MarkerData> markers
});




}
/// @nodoc
class _$KoemyakuDataCopyWithImpl<$Res>
    implements $KoemyakuDataCopyWith<$Res> {
  _$KoemyakuDataCopyWithImpl(this._self, this._then);

  final KoemyakuData _self;
  final $Res Function(KoemyakuData) _then;

/// Create a copy of KoemyakuData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? message = null,Object? createdAt = null,Object? updatedAt = freezed,Object? markers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,markers: null == markers ? _self.markers : markers // ignore: cast_nullable_to_non_nullable
as List<MarkerData>,
  ));
}

}


/// Adds pattern-matching-related methods to [KoemyakuData].
extension KoemyakuDataPatterns on KoemyakuData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KoemyakuData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KoemyakuData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KoemyakuData value)  $default,){
final _that = this;
switch (_that) {
case _KoemyakuData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KoemyakuData value)?  $default,){
final _that = this;
switch (_that) {
case _KoemyakuData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String message, @TimestampConverter()  DateTime createdAt, @NullableTimestampConverter()  DateTime? updatedAt,  List<MarkerData> markers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KoemyakuData() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.message,_that.createdAt,_that.updatedAt,_that.markers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String message, @TimestampConverter()  DateTime createdAt, @NullableTimestampConverter()  DateTime? updatedAt,  List<MarkerData> markers)  $default,) {final _that = this;
switch (_that) {
case _KoemyakuData():
return $default(_that.id,_that.userId,_that.title,_that.message,_that.createdAt,_that.updatedAt,_that.markers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String message, @TimestampConverter()  DateTime createdAt, @NullableTimestampConverter()  DateTime? updatedAt,  List<MarkerData> markers)?  $default,) {final _that = this;
switch (_that) {
case _KoemyakuData() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.message,_that.createdAt,_that.updatedAt,_that.markers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KoemyakuData extends KoemyakuData {
  const _KoemyakuData({required this.id, required this.userId, required this.title, this.message = '', @TimestampConverter() required this.createdAt, @NullableTimestampConverter() this.updatedAt, final  List<MarkerData> markers = const []}): _markers = markers,super._();
  factory _KoemyakuData.fromJson(Map<String, dynamic> json) => _$KoemyakuDataFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override@JsonKey() final  String message;
@override@TimestampConverter() final  DateTime createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;
 final  List<MarkerData> _markers;
@override@JsonKey() List<MarkerData> get markers {
  if (_markers is EqualUnmodifiableListView) return _markers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_markers);
}


/// Create a copy of KoemyakuData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KoemyakuDataCopyWith<_KoemyakuData> get copyWith => __$KoemyakuDataCopyWithImpl<_KoemyakuData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KoemyakuDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KoemyakuData&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._markers, _markers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,message,createdAt,updatedAt,const DeepCollectionEquality().hash(_markers));

@override
String toString() {
  return 'KoemyakuData(id: $id, userId: $userId, title: $title, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, markers: $markers)';
}


}

/// @nodoc
abstract mixin class _$KoemyakuDataCopyWith<$Res> implements $KoemyakuDataCopyWith<$Res> {
  factory _$KoemyakuDataCopyWith(_KoemyakuData value, $Res Function(_KoemyakuData) _then) = __$KoemyakuDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String message,@TimestampConverter() DateTime createdAt,@NullableTimestampConverter() DateTime? updatedAt, List<MarkerData> markers
});




}
/// @nodoc
class __$KoemyakuDataCopyWithImpl<$Res>
    implements _$KoemyakuDataCopyWith<$Res> {
  __$KoemyakuDataCopyWithImpl(this._self, this._then);

  final _KoemyakuData _self;
  final $Res Function(_KoemyakuData) _then;

/// Create a copy of KoemyakuData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? message = null,Object? createdAt = null,Object? updatedAt = freezed,Object? markers = null,}) {
  return _then(_KoemyakuData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,markers: null == markers ? _self._markers : markers // ignore: cast_nullable_to_non_nullable
as List<MarkerData>,
  ));
}


}

// dart format on
