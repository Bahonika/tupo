// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_enemy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveEnemy {

 EnemyData get data; double get x; double get y; double get targetX; double get targetY; double get startX; double get startY; MovementType get movementType; double get movementProgress; bool get isDestroyed; bool get hasReachedTarget;
/// Create a copy of ActiveEnemy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveEnemyCopyWith<ActiveEnemy> get copyWith => _$ActiveEnemyCopyWithImpl<ActiveEnemy>(this as ActiveEnemy, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveEnemy&&(identical(other.data, data) || other.data == data)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.targetX, targetX) || other.targetX == targetX)&&(identical(other.targetY, targetY) || other.targetY == targetY)&&(identical(other.startX, startX) || other.startX == startX)&&(identical(other.startY, startY) || other.startY == startY)&&(identical(other.movementType, movementType) || other.movementType == movementType)&&(identical(other.movementProgress, movementProgress) || other.movementProgress == movementProgress)&&(identical(other.isDestroyed, isDestroyed) || other.isDestroyed == isDestroyed)&&(identical(other.hasReachedTarget, hasReachedTarget) || other.hasReachedTarget == hasReachedTarget));
}


@override
int get hashCode => Object.hash(runtimeType,data,x,y,targetX,targetY,startX,startY,movementType,movementProgress,isDestroyed,hasReachedTarget);

@override
String toString() {
  return 'ActiveEnemy(data: $data, x: $x, y: $y, targetX: $targetX, targetY: $targetY, startX: $startX, startY: $startY, movementType: $movementType, movementProgress: $movementProgress, isDestroyed: $isDestroyed, hasReachedTarget: $hasReachedTarget)';
}


}

/// @nodoc
abstract mixin class $ActiveEnemyCopyWith<$Res>  {
  factory $ActiveEnemyCopyWith(ActiveEnemy value, $Res Function(ActiveEnemy) _then) = _$ActiveEnemyCopyWithImpl;
@useResult
$Res call({
 EnemyData data, double x, double y, double targetX, double targetY, double startX, double startY, MovementType movementType, double movementProgress, bool isDestroyed, bool hasReachedTarget
});


$EnemyDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ActiveEnemyCopyWithImpl<$Res>
    implements $ActiveEnemyCopyWith<$Res> {
  _$ActiveEnemyCopyWithImpl(this._self, this._then);

  final ActiveEnemy _self;
  final $Res Function(ActiveEnemy) _then;

/// Create a copy of ActiveEnemy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? x = null,Object? y = null,Object? targetX = null,Object? targetY = null,Object? startX = null,Object? startY = null,Object? movementType = null,Object? movementProgress = null,Object? isDestroyed = null,Object? hasReachedTarget = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EnemyData,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,targetX: null == targetX ? _self.targetX : targetX // ignore: cast_nullable_to_non_nullable
as double,targetY: null == targetY ? _self.targetY : targetY // ignore: cast_nullable_to_non_nullable
as double,startX: null == startX ? _self.startX : startX // ignore: cast_nullable_to_non_nullable
as double,startY: null == startY ? _self.startY : startY // ignore: cast_nullable_to_non_nullable
as double,movementType: null == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as MovementType,movementProgress: null == movementProgress ? _self.movementProgress : movementProgress // ignore: cast_nullable_to_non_nullable
as double,isDestroyed: null == isDestroyed ? _self.isDestroyed : isDestroyed // ignore: cast_nullable_to_non_nullable
as bool,hasReachedTarget: null == hasReachedTarget ? _self.hasReachedTarget : hasReachedTarget // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ActiveEnemy
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnemyDataCopyWith<$Res> get data {
  
  return $EnemyDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActiveEnemy].
extension ActiveEnemyPatterns on ActiveEnemy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveEnemy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveEnemy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveEnemy value)  $default,){
final _that = this;
switch (_that) {
case _ActiveEnemy():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveEnemy value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveEnemy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EnemyData data,  double x,  double y,  double targetX,  double targetY,  double startX,  double startY,  MovementType movementType,  double movementProgress,  bool isDestroyed,  bool hasReachedTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveEnemy() when $default != null:
return $default(_that.data,_that.x,_that.y,_that.targetX,_that.targetY,_that.startX,_that.startY,_that.movementType,_that.movementProgress,_that.isDestroyed,_that.hasReachedTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EnemyData data,  double x,  double y,  double targetX,  double targetY,  double startX,  double startY,  MovementType movementType,  double movementProgress,  bool isDestroyed,  bool hasReachedTarget)  $default,) {final _that = this;
switch (_that) {
case _ActiveEnemy():
return $default(_that.data,_that.x,_that.y,_that.targetX,_that.targetY,_that.startX,_that.startY,_that.movementType,_that.movementProgress,_that.isDestroyed,_that.hasReachedTarget);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EnemyData data,  double x,  double y,  double targetX,  double targetY,  double startX,  double startY,  MovementType movementType,  double movementProgress,  bool isDestroyed,  bool hasReachedTarget)?  $default,) {final _that = this;
switch (_that) {
case _ActiveEnemy() when $default != null:
return $default(_that.data,_that.x,_that.y,_that.targetX,_that.targetY,_that.startX,_that.startY,_that.movementType,_that.movementProgress,_that.isDestroyed,_that.hasReachedTarget);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveEnemy implements ActiveEnemy {
  const _ActiveEnemy({required this.data, required this.x, required this.y, required this.targetX, required this.targetY, required this.startX, required this.startY, this.movementType = MovementType.straight, this.movementProgress = 0.0, this.isDestroyed = false, this.hasReachedTarget = false});
  

@override final  EnemyData data;
@override final  double x;
@override final  double y;
@override final  double targetX;
@override final  double targetY;
@override final  double startX;
@override final  double startY;
@override@JsonKey() final  MovementType movementType;
@override@JsonKey() final  double movementProgress;
@override@JsonKey() final  bool isDestroyed;
@override@JsonKey() final  bool hasReachedTarget;

/// Create a copy of ActiveEnemy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveEnemyCopyWith<_ActiveEnemy> get copyWith => __$ActiveEnemyCopyWithImpl<_ActiveEnemy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveEnemy&&(identical(other.data, data) || other.data == data)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.targetX, targetX) || other.targetX == targetX)&&(identical(other.targetY, targetY) || other.targetY == targetY)&&(identical(other.startX, startX) || other.startX == startX)&&(identical(other.startY, startY) || other.startY == startY)&&(identical(other.movementType, movementType) || other.movementType == movementType)&&(identical(other.movementProgress, movementProgress) || other.movementProgress == movementProgress)&&(identical(other.isDestroyed, isDestroyed) || other.isDestroyed == isDestroyed)&&(identical(other.hasReachedTarget, hasReachedTarget) || other.hasReachedTarget == hasReachedTarget));
}


@override
int get hashCode => Object.hash(runtimeType,data,x,y,targetX,targetY,startX,startY,movementType,movementProgress,isDestroyed,hasReachedTarget);

@override
String toString() {
  return 'ActiveEnemy(data: $data, x: $x, y: $y, targetX: $targetX, targetY: $targetY, startX: $startX, startY: $startY, movementType: $movementType, movementProgress: $movementProgress, isDestroyed: $isDestroyed, hasReachedTarget: $hasReachedTarget)';
}


}

/// @nodoc
abstract mixin class _$ActiveEnemyCopyWith<$Res> implements $ActiveEnemyCopyWith<$Res> {
  factory _$ActiveEnemyCopyWith(_ActiveEnemy value, $Res Function(_ActiveEnemy) _then) = __$ActiveEnemyCopyWithImpl;
@override @useResult
$Res call({
 EnemyData data, double x, double y, double targetX, double targetY, double startX, double startY, MovementType movementType, double movementProgress, bool isDestroyed, bool hasReachedTarget
});


@override $EnemyDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ActiveEnemyCopyWithImpl<$Res>
    implements _$ActiveEnemyCopyWith<$Res> {
  __$ActiveEnemyCopyWithImpl(this._self, this._then);

  final _ActiveEnemy _self;
  final $Res Function(_ActiveEnemy) _then;

/// Create a copy of ActiveEnemy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? x = null,Object? y = null,Object? targetX = null,Object? targetY = null,Object? startX = null,Object? startY = null,Object? movementType = null,Object? movementProgress = null,Object? isDestroyed = null,Object? hasReachedTarget = null,}) {
  return _then(_ActiveEnemy(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EnemyData,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,targetX: null == targetX ? _self.targetX : targetX // ignore: cast_nullable_to_non_nullable
as double,targetY: null == targetY ? _self.targetY : targetY // ignore: cast_nullable_to_non_nullable
as double,startX: null == startX ? _self.startX : startX // ignore: cast_nullable_to_non_nullable
as double,startY: null == startY ? _self.startY : startY // ignore: cast_nullable_to_non_nullable
as double,movementType: null == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as MovementType,movementProgress: null == movementProgress ? _self.movementProgress : movementProgress // ignore: cast_nullable_to_non_nullable
as double,isDestroyed: null == isDestroyed ? _self.isDestroyed : isDestroyed // ignore: cast_nullable_to_non_nullable
as bool,hasReachedTarget: null == hasReachedTarget ? _self.hasReachedTarget : hasReachedTarget // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ActiveEnemy
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnemyDataCopyWith<$Res> get data {
  
  return $EnemyDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
