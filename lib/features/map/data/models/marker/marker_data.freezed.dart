// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marker_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkerData {

 String get id; double get latitude; double get longitude; double get radius; String? get voicePath; List<double> get amplitudes; DateTime? get createdAt;
/// Create a copy of MarkerData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkerDataCopyWith<MarkerData> get copyWith => _$MarkerDataCopyWithImpl<MarkerData>(this as MarkerData, _$identity);

  /// Serializes this MarkerData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkerData&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.voicePath, voicePath) || other.voicePath == voicePath)&&const DeepCollectionEquality().equals(other.amplitudes, amplitudes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,radius,voicePath,const DeepCollectionEquality().hash(amplitudes),createdAt);

@override
String toString() {
  return 'MarkerData(id: $id, latitude: $latitude, longitude: $longitude, radius: $radius, voicePath: $voicePath, amplitudes: $amplitudes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MarkerDataCopyWith<$Res>  {
  factory $MarkerDataCopyWith(MarkerData value, $Res Function(MarkerData) _then) = _$MarkerDataCopyWithImpl;
@useResult
$Res call({
 String id, double latitude, double longitude, double radius, String? voicePath, List<double> amplitudes, DateTime? createdAt
});




}
/// @nodoc
class _$MarkerDataCopyWithImpl<$Res>
    implements $MarkerDataCopyWith<$Res> {
  _$MarkerDataCopyWithImpl(this._self, this._then);

  final MarkerData _self;
  final $Res Function(MarkerData) _then;

/// Create a copy of MarkerData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? latitude = null,Object? longitude = null,Object? radius = null,Object? voicePath = freezed,Object? amplitudes = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,voicePath: freezed == voicePath ? _self.voicePath : voicePath // ignore: cast_nullable_to_non_nullable
as String?,amplitudes: null == amplitudes ? _self.amplitudes : amplitudes // ignore: cast_nullable_to_non_nullable
as List<double>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarkerData].
extension MarkerDataPatterns on MarkerData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarkerData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarkerData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarkerData value)  $default,){
final _that = this;
switch (_that) {
case _MarkerData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarkerData value)?  $default,){
final _that = this;
switch (_that) {
case _MarkerData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double latitude,  double longitude,  double radius,  String? voicePath,  List<double> amplitudes,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarkerData() when $default != null:
return $default(_that.id,_that.latitude,_that.longitude,_that.radius,_that.voicePath,_that.amplitudes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double latitude,  double longitude,  double radius,  String? voicePath,  List<double> amplitudes,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MarkerData():
return $default(_that.id,_that.latitude,_that.longitude,_that.radius,_that.voicePath,_that.amplitudes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double latitude,  double longitude,  double radius,  String? voicePath,  List<double> amplitudes,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MarkerData() when $default != null:
return $default(_that.id,_that.latitude,_that.longitude,_that.radius,_that.voicePath,_that.amplitudes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarkerData extends MarkerData {
  const _MarkerData({required this.id, required this.latitude, required this.longitude, this.radius = 10.0, this.voicePath, final  List<double> amplitudes = const [], this.createdAt}): _amplitudes = amplitudes,super._();
  factory _MarkerData.fromJson(Map<String, dynamic> json) => _$MarkerDataFromJson(json);

@override final  String id;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey() final  double radius;
@override final  String? voicePath;
 final  List<double> _amplitudes;
@override@JsonKey() List<double> get amplitudes {
  if (_amplitudes is EqualUnmodifiableListView) return _amplitudes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amplitudes);
}

@override final  DateTime? createdAt;

/// Create a copy of MarkerData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkerDataCopyWith<_MarkerData> get copyWith => __$MarkerDataCopyWithImpl<_MarkerData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkerDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarkerData&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.voicePath, voicePath) || other.voicePath == voicePath)&&const DeepCollectionEquality().equals(other._amplitudes, _amplitudes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,radius,voicePath,const DeepCollectionEquality().hash(_amplitudes),createdAt);

@override
String toString() {
  return 'MarkerData(id: $id, latitude: $latitude, longitude: $longitude, radius: $radius, voicePath: $voicePath, amplitudes: $amplitudes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MarkerDataCopyWith<$Res> implements $MarkerDataCopyWith<$Res> {
  factory _$MarkerDataCopyWith(_MarkerData value, $Res Function(_MarkerData) _then) = __$MarkerDataCopyWithImpl;
@override @useResult
$Res call({
 String id, double latitude, double longitude, double radius, String? voicePath, List<double> amplitudes, DateTime? createdAt
});




}
/// @nodoc
class __$MarkerDataCopyWithImpl<$Res>
    implements _$MarkerDataCopyWith<$Res> {
  __$MarkerDataCopyWithImpl(this._self, this._then);

  final _MarkerData _self;
  final $Res Function(_MarkerData) _then;

/// Create a copy of MarkerData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? latitude = null,Object? longitude = null,Object? radius = null,Object? voicePath = freezed,Object? amplitudes = null,Object? createdAt = freezed,}) {
  return _then(_MarkerData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,voicePath: freezed == voicePath ? _self.voicePath : voicePath // ignore: cast_nullable_to_non_nullable
as String?,amplitudes: null == amplitudes ? _self._amplitudes : amplitudes // ignore: cast_nullable_to_non_nullable
as List<double>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
