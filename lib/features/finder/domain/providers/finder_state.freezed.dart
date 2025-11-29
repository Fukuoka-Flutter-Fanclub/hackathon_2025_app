// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinderState {

/// 現在のステータス
 FinderStatus get status;/// 全マーカーリスト
 List<MarkerData> get allMarkers;/// 訪問済みマーカーのID
 Set<String> get visitedMarkerIds;/// 現在のターゲットマーカー
 MarkerData? get currentTarget;/// 現在地からターゲットまでの距離（メートル）
 double get distanceToTarget;/// 現在地からターゲットへの方角（度数法、北が0度）
 double get bearingToTarget;/// ユーザーが向いている方角（コンパス）
 double get userHeading;/// 現在の緯度
 double get currentLatitude;/// 現在の経度
 double get currentLongitude;/// エラーメッセージ
 String? get errorMessage;
/// Create a copy of FinderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinderStateCopyWith<FinderState> get copyWith => _$FinderStateCopyWithImpl<FinderState>(this as FinderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinderState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.allMarkers, allMarkers)&&const DeepCollectionEquality().equals(other.visitedMarkerIds, visitedMarkerIds)&&(identical(other.currentTarget, currentTarget) || other.currentTarget == currentTarget)&&(identical(other.distanceToTarget, distanceToTarget) || other.distanceToTarget == distanceToTarget)&&(identical(other.bearingToTarget, bearingToTarget) || other.bearingToTarget == bearingToTarget)&&(identical(other.userHeading, userHeading) || other.userHeading == userHeading)&&(identical(other.currentLatitude, currentLatitude) || other.currentLatitude == currentLatitude)&&(identical(other.currentLongitude, currentLongitude) || other.currentLongitude == currentLongitude)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(allMarkers),const DeepCollectionEquality().hash(visitedMarkerIds),currentTarget,distanceToTarget,bearingToTarget,userHeading,currentLatitude,currentLongitude,errorMessage);

@override
String toString() {
  return 'FinderState(status: $status, allMarkers: $allMarkers, visitedMarkerIds: $visitedMarkerIds, currentTarget: $currentTarget, distanceToTarget: $distanceToTarget, bearingToTarget: $bearingToTarget, userHeading: $userHeading, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FinderStateCopyWith<$Res>  {
  factory $FinderStateCopyWith(FinderState value, $Res Function(FinderState) _then) = _$FinderStateCopyWithImpl;
@useResult
$Res call({
 FinderStatus status, List<MarkerData> allMarkers, Set<String> visitedMarkerIds, MarkerData? currentTarget, double distanceToTarget, double bearingToTarget, double userHeading, double currentLatitude, double currentLongitude, String? errorMessage
});


$MarkerDataCopyWith<$Res>? get currentTarget;

}
/// @nodoc
class _$FinderStateCopyWithImpl<$Res>
    implements $FinderStateCopyWith<$Res> {
  _$FinderStateCopyWithImpl(this._self, this._then);

  final FinderState _self;
  final $Res Function(FinderState) _then;

/// Create a copy of FinderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? allMarkers = null,Object? visitedMarkerIds = null,Object? currentTarget = freezed,Object? distanceToTarget = null,Object? bearingToTarget = null,Object? userHeading = null,Object? currentLatitude = null,Object? currentLongitude = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FinderStatus,allMarkers: null == allMarkers ? _self.allMarkers : allMarkers // ignore: cast_nullable_to_non_nullable
as List<MarkerData>,visitedMarkerIds: null == visitedMarkerIds ? _self.visitedMarkerIds : visitedMarkerIds // ignore: cast_nullable_to_non_nullable
as Set<String>,currentTarget: freezed == currentTarget ? _self.currentTarget : currentTarget // ignore: cast_nullable_to_non_nullable
as MarkerData?,distanceToTarget: null == distanceToTarget ? _self.distanceToTarget : distanceToTarget // ignore: cast_nullable_to_non_nullable
as double,bearingToTarget: null == bearingToTarget ? _self.bearingToTarget : bearingToTarget // ignore: cast_nullable_to_non_nullable
as double,userHeading: null == userHeading ? _self.userHeading : userHeading // ignore: cast_nullable_to_non_nullable
as double,currentLatitude: null == currentLatitude ? _self.currentLatitude : currentLatitude // ignore: cast_nullable_to_non_nullable
as double,currentLongitude: null == currentLongitude ? _self.currentLongitude : currentLongitude // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FinderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarkerDataCopyWith<$Res>? get currentTarget {
    if (_self.currentTarget == null) {
    return null;
  }

  return $MarkerDataCopyWith<$Res>(_self.currentTarget!, (value) {
    return _then(_self.copyWith(currentTarget: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinderState].
extension FinderStatePatterns on FinderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinderState value)  $default,){
final _that = this;
switch (_that) {
case _FinderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinderState value)?  $default,){
final _that = this;
switch (_that) {
case _FinderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FinderStatus status,  List<MarkerData> allMarkers,  Set<String> visitedMarkerIds,  MarkerData? currentTarget,  double distanceToTarget,  double bearingToTarget,  double userHeading,  double currentLatitude,  double currentLongitude,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinderState() when $default != null:
return $default(_that.status,_that.allMarkers,_that.visitedMarkerIds,_that.currentTarget,_that.distanceToTarget,_that.bearingToTarget,_that.userHeading,_that.currentLatitude,_that.currentLongitude,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FinderStatus status,  List<MarkerData> allMarkers,  Set<String> visitedMarkerIds,  MarkerData? currentTarget,  double distanceToTarget,  double bearingToTarget,  double userHeading,  double currentLatitude,  double currentLongitude,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _FinderState():
return $default(_that.status,_that.allMarkers,_that.visitedMarkerIds,_that.currentTarget,_that.distanceToTarget,_that.bearingToTarget,_that.userHeading,_that.currentLatitude,_that.currentLongitude,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FinderStatus status,  List<MarkerData> allMarkers,  Set<String> visitedMarkerIds,  MarkerData? currentTarget,  double distanceToTarget,  double bearingToTarget,  double userHeading,  double currentLatitude,  double currentLongitude,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _FinderState() when $default != null:
return $default(_that.status,_that.allMarkers,_that.visitedMarkerIds,_that.currentTarget,_that.distanceToTarget,_that.bearingToTarget,_that.userHeading,_that.currentLatitude,_that.currentLongitude,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _FinderState extends FinderState {
  const _FinderState({this.status = FinderStatus.initializing, final  List<MarkerData> allMarkers = const [], final  Set<String> visitedMarkerIds = const {}, this.currentTarget, this.distanceToTarget = 0, this.bearingToTarget = 0, this.userHeading = 0, this.currentLatitude = 0, this.currentLongitude = 0, this.errorMessage}): _allMarkers = allMarkers,_visitedMarkerIds = visitedMarkerIds,super._();
  

/// 現在のステータス
@override@JsonKey() final  FinderStatus status;
/// 全マーカーリスト
 final  List<MarkerData> _allMarkers;
/// 全マーカーリスト
@override@JsonKey() List<MarkerData> get allMarkers {
  if (_allMarkers is EqualUnmodifiableListView) return _allMarkers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allMarkers);
}

/// 訪問済みマーカーのID
 final  Set<String> _visitedMarkerIds;
/// 訪問済みマーカーのID
@override@JsonKey() Set<String> get visitedMarkerIds {
  if (_visitedMarkerIds is EqualUnmodifiableSetView) return _visitedMarkerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_visitedMarkerIds);
}

/// 現在のターゲットマーカー
@override final  MarkerData? currentTarget;
/// 現在地からターゲットまでの距離（メートル）
@override@JsonKey() final  double distanceToTarget;
/// 現在地からターゲットへの方角（度数法、北が0度）
@override@JsonKey() final  double bearingToTarget;
/// ユーザーが向いている方角（コンパス）
@override@JsonKey() final  double userHeading;
/// 現在の緯度
@override@JsonKey() final  double currentLatitude;
/// 現在の経度
@override@JsonKey() final  double currentLongitude;
/// エラーメッセージ
@override final  String? errorMessage;

/// Create a copy of FinderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinderStateCopyWith<_FinderState> get copyWith => __$FinderStateCopyWithImpl<_FinderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinderState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._allMarkers, _allMarkers)&&const DeepCollectionEquality().equals(other._visitedMarkerIds, _visitedMarkerIds)&&(identical(other.currentTarget, currentTarget) || other.currentTarget == currentTarget)&&(identical(other.distanceToTarget, distanceToTarget) || other.distanceToTarget == distanceToTarget)&&(identical(other.bearingToTarget, bearingToTarget) || other.bearingToTarget == bearingToTarget)&&(identical(other.userHeading, userHeading) || other.userHeading == userHeading)&&(identical(other.currentLatitude, currentLatitude) || other.currentLatitude == currentLatitude)&&(identical(other.currentLongitude, currentLongitude) || other.currentLongitude == currentLongitude)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_allMarkers),const DeepCollectionEquality().hash(_visitedMarkerIds),currentTarget,distanceToTarget,bearingToTarget,userHeading,currentLatitude,currentLongitude,errorMessage);

@override
String toString() {
  return 'FinderState(status: $status, allMarkers: $allMarkers, visitedMarkerIds: $visitedMarkerIds, currentTarget: $currentTarget, distanceToTarget: $distanceToTarget, bearingToTarget: $bearingToTarget, userHeading: $userHeading, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$FinderStateCopyWith<$Res> implements $FinderStateCopyWith<$Res> {
  factory _$FinderStateCopyWith(_FinderState value, $Res Function(_FinderState) _then) = __$FinderStateCopyWithImpl;
@override @useResult
$Res call({
 FinderStatus status, List<MarkerData> allMarkers, Set<String> visitedMarkerIds, MarkerData? currentTarget, double distanceToTarget, double bearingToTarget, double userHeading, double currentLatitude, double currentLongitude, String? errorMessage
});


@override $MarkerDataCopyWith<$Res>? get currentTarget;

}
/// @nodoc
class __$FinderStateCopyWithImpl<$Res>
    implements _$FinderStateCopyWith<$Res> {
  __$FinderStateCopyWithImpl(this._self, this._then);

  final _FinderState _self;
  final $Res Function(_FinderState) _then;

/// Create a copy of FinderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? allMarkers = null,Object? visitedMarkerIds = null,Object? currentTarget = freezed,Object? distanceToTarget = null,Object? bearingToTarget = null,Object? userHeading = null,Object? currentLatitude = null,Object? currentLongitude = null,Object? errorMessage = freezed,}) {
  return _then(_FinderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FinderStatus,allMarkers: null == allMarkers ? _self._allMarkers : allMarkers // ignore: cast_nullable_to_non_nullable
as List<MarkerData>,visitedMarkerIds: null == visitedMarkerIds ? _self._visitedMarkerIds : visitedMarkerIds // ignore: cast_nullable_to_non_nullable
as Set<String>,currentTarget: freezed == currentTarget ? _self.currentTarget : currentTarget // ignore: cast_nullable_to_non_nullable
as MarkerData?,distanceToTarget: null == distanceToTarget ? _self.distanceToTarget : distanceToTarget // ignore: cast_nullable_to_non_nullable
as double,bearingToTarget: null == bearingToTarget ? _self.bearingToTarget : bearingToTarget // ignore: cast_nullable_to_non_nullable
as double,userHeading: null == userHeading ? _self.userHeading : userHeading // ignore: cast_nullable_to_non_nullable
as double,currentLatitude: null == currentLatitude ? _self.currentLatitude : currentLatitude // ignore: cast_nullable_to_non_nullable
as double,currentLongitude: null == currentLongitude ? _self.currentLongitude : currentLongitude // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FinderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarkerDataCopyWith<$Res>? get currentTarget {
    if (_self.currentTarget == null) {
    return null;
  }

  return $MarkerDataCopyWith<$Res>(_self.currentTarget!, (value) {
    return _then(_self.copyWith(currentTarget: value));
  });
}
}

// dart format on
