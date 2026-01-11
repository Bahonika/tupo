// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enemy_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnemyData {

 String get id; String get word; double get speed; int get damage; EnemyType get type;
/// Create a copy of EnemyData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnemyDataCopyWith<EnemyData> get copyWith => _$EnemyDataCopyWithImpl<EnemyData>(this as EnemyData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnemyData&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.damage, damage) || other.damage == damage)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,word,speed,damage,type);

@override
String toString() {
  return 'EnemyData(id: $id, word: $word, speed: $speed, damage: $damage, type: $type)';
}


}

/// @nodoc
abstract mixin class $EnemyDataCopyWith<$Res>  {
  factory $EnemyDataCopyWith(EnemyData value, $Res Function(EnemyData) _then) = _$EnemyDataCopyWithImpl;
@useResult
$Res call({
 String id, String word, double speed, int damage, EnemyType type
});




}
/// @nodoc
class _$EnemyDataCopyWithImpl<$Res>
    implements $EnemyDataCopyWith<$Res> {
  _$EnemyDataCopyWithImpl(this._self, this._then);

  final EnemyData _self;
  final $Res Function(EnemyData) _then;

/// Create a copy of EnemyData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? word = null,Object? speed = null,Object? damage = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EnemyType,
  ));
}

}


/// Adds pattern-matching-related methods to [EnemyData].
extension EnemyDataPatterns on EnemyData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnemyData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnemyData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnemyData value)  $default,){
final _that = this;
switch (_that) {
case _EnemyData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnemyData value)?  $default,){
final _that = this;
switch (_that) {
case _EnemyData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String word,  double speed,  int damage,  EnemyType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnemyData() when $default != null:
return $default(_that.id,_that.word,_that.speed,_that.damage,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String word,  double speed,  int damage,  EnemyType type)  $default,) {final _that = this;
switch (_that) {
case _EnemyData():
return $default(_that.id,_that.word,_that.speed,_that.damage,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String word,  double speed,  int damage,  EnemyType type)?  $default,) {final _that = this;
switch (_that) {
case _EnemyData() when $default != null:
return $default(_that.id,_that.word,_that.speed,_that.damage,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _EnemyData implements EnemyData {
  const _EnemyData({required this.id, required this.word, required this.speed, required this.damage, this.type = EnemyType.normal});
  

@override final  String id;
@override final  String word;
@override final  double speed;
@override final  int damage;
@override@JsonKey() final  EnemyType type;

/// Create a copy of EnemyData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnemyDataCopyWith<_EnemyData> get copyWith => __$EnemyDataCopyWithImpl<_EnemyData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnemyData&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.damage, damage) || other.damage == damage)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,word,speed,damage,type);

@override
String toString() {
  return 'EnemyData(id: $id, word: $word, speed: $speed, damage: $damage, type: $type)';
}


}

/// @nodoc
abstract mixin class _$EnemyDataCopyWith<$Res> implements $EnemyDataCopyWith<$Res> {
  factory _$EnemyDataCopyWith(_EnemyData value, $Res Function(_EnemyData) _then) = __$EnemyDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String word, double speed, int damage, EnemyType type
});




}
/// @nodoc
class __$EnemyDataCopyWithImpl<$Res>
    implements _$EnemyDataCopyWith<$Res> {
  __$EnemyDataCopyWithImpl(this._self, this._then);

  final _EnemyData _self;
  final $Res Function(_EnemyData) _then;

/// Create a copy of EnemyData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? word = null,Object? speed = null,Object? damage = null,Object? type = null,}) {
  return _then(_EnemyData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EnemyType,
  ));
}


}

// dart format on
