// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'target_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TargetState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TargetState()';
}


}

/// @nodoc
class $TargetStateCopyWith<$Res>  {
$TargetStateCopyWith(TargetState _, $Res Function(TargetState) __);
}


/// Adds pattern-matching-related methods to [TargetState].
extension TargetStatePatterns on TargetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _None value)?  none,TResult Function( _Selected value)?  selected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _None() when none != null:
return none(_that);case _Selected() when selected != null:
return selected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _None value)  none,required TResult Function( _Selected value)  selected,}){
final _that = this;
switch (_that) {
case _None():
return none(_that);case _Selected():
return selected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _None value)?  none,TResult? Function( _Selected value)?  selected,}){
final _that = this;
switch (_that) {
case _None() when none != null:
return none(_that);case _Selected() when selected != null:
return selected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( String enemyId,  String word)?  selected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _None() when none != null:
return none();case _Selected() when selected != null:
return selected(_that.enemyId,_that.word);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( String enemyId,  String word)  selected,}) {final _that = this;
switch (_that) {
case _None():
return none();case _Selected():
return selected(_that.enemyId,_that.word);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( String enemyId,  String word)?  selected,}) {final _that = this;
switch (_that) {
case _None() when none != null:
return none();case _Selected() when selected != null:
return selected(_that.enemyId,_that.word);case _:
  return null;

}
}

}

/// @nodoc


class _None extends TargetState {
  const _None(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _None);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TargetState.none()';
}


}




/// @nodoc


class _Selected extends TargetState {
  const _Selected({required this.enemyId, required this.word}): super._();
  

/// ID врага-цели
 final  String enemyId;
/// Слово цели
 final  String word;

/// Create a copy of TargetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedCopyWith<_Selected> get copyWith => __$SelectedCopyWithImpl<_Selected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Selected&&(identical(other.enemyId, enemyId) || other.enemyId == enemyId)&&(identical(other.word, word) || other.word == word));
}


@override
int get hashCode => Object.hash(runtimeType,enemyId,word);

@override
String toString() {
  return 'TargetState.selected(enemyId: $enemyId, word: $word)';
}


}

/// @nodoc
abstract mixin class _$SelectedCopyWith<$Res> implements $TargetStateCopyWith<$Res> {
  factory _$SelectedCopyWith(_Selected value, $Res Function(_Selected) _then) = __$SelectedCopyWithImpl;
@useResult
$Res call({
 String enemyId, String word
});




}
/// @nodoc
class __$SelectedCopyWithImpl<$Res>
    implements _$SelectedCopyWith<$Res> {
  __$SelectedCopyWithImpl(this._self, this._then);

  final _Selected _self;
  final $Res Function(_Selected) _then;

/// Create a copy of TargetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enemyId = null,Object? word = null,}) {
  return _then(_Selected(
enemyId: null == enemyId ? _self.enemyId : enemyId // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
