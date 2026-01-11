// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enemies_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnemiesState {

/// Активные враги на поле (id -> данные)
 Map<String, ActiveEnemy> get activeEnemies;/// Флаг активности спавна врагов
 bool get isSpawning;/// ID последнего убитого врага (для уведомления Presentation об эффекте)
 String? get lastKilledEnemyId;/// ID последнего врага, достигшего игрока
 String? get lastCollidedEnemyId;
/// Create a copy of EnemiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnemiesStateCopyWith<EnemiesState> get copyWith => _$EnemiesStateCopyWithImpl<EnemiesState>(this as EnemiesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnemiesState&&const DeepCollectionEquality().equals(other.activeEnemies, activeEnemies)&&(identical(other.isSpawning, isSpawning) || other.isSpawning == isSpawning)&&(identical(other.lastKilledEnemyId, lastKilledEnemyId) || other.lastKilledEnemyId == lastKilledEnemyId)&&(identical(other.lastCollidedEnemyId, lastCollidedEnemyId) || other.lastCollidedEnemyId == lastCollidedEnemyId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(activeEnemies),isSpawning,lastKilledEnemyId,lastCollidedEnemyId);

@override
String toString() {
  return 'EnemiesState(activeEnemies: $activeEnemies, isSpawning: $isSpawning, lastKilledEnemyId: $lastKilledEnemyId, lastCollidedEnemyId: $lastCollidedEnemyId)';
}


}

/// @nodoc
abstract mixin class $EnemiesStateCopyWith<$Res>  {
  factory $EnemiesStateCopyWith(EnemiesState value, $Res Function(EnemiesState) _then) = _$EnemiesStateCopyWithImpl;
@useResult
$Res call({
 Map<String, ActiveEnemy> activeEnemies, bool isSpawning, String? lastKilledEnemyId, String? lastCollidedEnemyId
});




}
/// @nodoc
class _$EnemiesStateCopyWithImpl<$Res>
    implements $EnemiesStateCopyWith<$Res> {
  _$EnemiesStateCopyWithImpl(this._self, this._then);

  final EnemiesState _self;
  final $Res Function(EnemiesState) _then;

/// Create a copy of EnemiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeEnemies = null,Object? isSpawning = null,Object? lastKilledEnemyId = freezed,Object? lastCollidedEnemyId = freezed,}) {
  return _then(_self.copyWith(
activeEnemies: null == activeEnemies ? _self.activeEnemies : activeEnemies // ignore: cast_nullable_to_non_nullable
as Map<String, ActiveEnemy>,isSpawning: null == isSpawning ? _self.isSpawning : isSpawning // ignore: cast_nullable_to_non_nullable
as bool,lastKilledEnemyId: freezed == lastKilledEnemyId ? _self.lastKilledEnemyId : lastKilledEnemyId // ignore: cast_nullable_to_non_nullable
as String?,lastCollidedEnemyId: freezed == lastCollidedEnemyId ? _self.lastCollidedEnemyId : lastCollidedEnemyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnemiesState].
extension EnemiesStatePatterns on EnemiesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnemiesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnemiesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnemiesState value)  $default,){
final _that = this;
switch (_that) {
case _EnemiesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnemiesState value)?  $default,){
final _that = this;
switch (_that) {
case _EnemiesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, ActiveEnemy> activeEnemies,  bool isSpawning,  String? lastKilledEnemyId,  String? lastCollidedEnemyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnemiesState() when $default != null:
return $default(_that.activeEnemies,_that.isSpawning,_that.lastKilledEnemyId,_that.lastCollidedEnemyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, ActiveEnemy> activeEnemies,  bool isSpawning,  String? lastKilledEnemyId,  String? lastCollidedEnemyId)  $default,) {final _that = this;
switch (_that) {
case _EnemiesState():
return $default(_that.activeEnemies,_that.isSpawning,_that.lastKilledEnemyId,_that.lastCollidedEnemyId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, ActiveEnemy> activeEnemies,  bool isSpawning,  String? lastKilledEnemyId,  String? lastCollidedEnemyId)?  $default,) {final _that = this;
switch (_that) {
case _EnemiesState() when $default != null:
return $default(_that.activeEnemies,_that.isSpawning,_that.lastKilledEnemyId,_that.lastCollidedEnemyId);case _:
  return null;

}
}

}

/// @nodoc


class _EnemiesState implements EnemiesState {
  const _EnemiesState({final  Map<String, ActiveEnemy> activeEnemies = const {}, this.isSpawning = false, this.lastKilledEnemyId, this.lastCollidedEnemyId}): _activeEnemies = activeEnemies;
  

/// Активные враги на поле (id -> данные)
 final  Map<String, ActiveEnemy> _activeEnemies;
/// Активные враги на поле (id -> данные)
@override@JsonKey() Map<String, ActiveEnemy> get activeEnemies {
  if (_activeEnemies is EqualUnmodifiableMapView) return _activeEnemies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_activeEnemies);
}

/// Флаг активности спавна врагов
@override@JsonKey() final  bool isSpawning;
/// ID последнего убитого врага (для уведомления Presentation об эффекте)
@override final  String? lastKilledEnemyId;
/// ID последнего врага, достигшего игрока
@override final  String? lastCollidedEnemyId;

/// Create a copy of EnemiesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnemiesStateCopyWith<_EnemiesState> get copyWith => __$EnemiesStateCopyWithImpl<_EnemiesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnemiesState&&const DeepCollectionEquality().equals(other._activeEnemies, _activeEnemies)&&(identical(other.isSpawning, isSpawning) || other.isSpawning == isSpawning)&&(identical(other.lastKilledEnemyId, lastKilledEnemyId) || other.lastKilledEnemyId == lastKilledEnemyId)&&(identical(other.lastCollidedEnemyId, lastCollidedEnemyId) || other.lastCollidedEnemyId == lastCollidedEnemyId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_activeEnemies),isSpawning,lastKilledEnemyId,lastCollidedEnemyId);

@override
String toString() {
  return 'EnemiesState(activeEnemies: $activeEnemies, isSpawning: $isSpawning, lastKilledEnemyId: $lastKilledEnemyId, lastCollidedEnemyId: $lastCollidedEnemyId)';
}


}

/// @nodoc
abstract mixin class _$EnemiesStateCopyWith<$Res> implements $EnemiesStateCopyWith<$Res> {
  factory _$EnemiesStateCopyWith(_EnemiesState value, $Res Function(_EnemiesState) _then) = __$EnemiesStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, ActiveEnemy> activeEnemies, bool isSpawning, String? lastKilledEnemyId, String? lastCollidedEnemyId
});




}
/// @nodoc
class __$EnemiesStateCopyWithImpl<$Res>
    implements _$EnemiesStateCopyWith<$Res> {
  __$EnemiesStateCopyWithImpl(this._self, this._then);

  final _EnemiesState _self;
  final $Res Function(_EnemiesState) _then;

/// Create a copy of EnemiesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeEnemies = null,Object? isSpawning = null,Object? lastKilledEnemyId = freezed,Object? lastCollidedEnemyId = freezed,}) {
  return _then(_EnemiesState(
activeEnemies: null == activeEnemies ? _self._activeEnemies : activeEnemies // ignore: cast_nullable_to_non_nullable
as Map<String, ActiveEnemy>,isSpawning: null == isSpawning ? _self.isSpawning : isSpawning // ignore: cast_nullable_to_non_nullable
as bool,lastKilledEnemyId: freezed == lastKilledEnemyId ? _self.lastKilledEnemyId : lastKilledEnemyId // ignore: cast_nullable_to_non_nullable
as String?,lastCollidedEnemyId: freezed == lastCollidedEnemyId ? _self.lastCollidedEnemyId : lastCollidedEnemyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
