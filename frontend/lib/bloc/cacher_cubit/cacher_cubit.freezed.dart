// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cacher_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CacherState implements DiagnosticableTreeMixin {

 Set<String> get caching; Set<String> get cached; Set<String> get unsuccessful; int get available;
/// Create a copy of CacherState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacherStateCopyWith<CacherState> get copyWith => _$CacherStateCopyWithImpl<CacherState>(this as CacherState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CacherState'))
    ..add(DiagnosticsProperty('caching', caching))..add(DiagnosticsProperty('cached', cached))..add(DiagnosticsProperty('unsuccessful', unsuccessful))..add(DiagnosticsProperty('available', available));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacherState&&const DeepCollectionEquality().equals(other.caching, caching)&&const DeepCollectionEquality().equals(other.cached, cached)&&const DeepCollectionEquality().equals(other.unsuccessful, unsuccessful)&&(identical(other.available, available) || other.available == available));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(caching),const DeepCollectionEquality().hash(cached),const DeepCollectionEquality().hash(unsuccessful),available);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CacherState(caching: $caching, cached: $cached, unsuccessful: $unsuccessful, available: $available)';
}


}

/// @nodoc
abstract mixin class $CacherStateCopyWith<$Res>  {
  factory $CacherStateCopyWith(CacherState value, $Res Function(CacherState) _then) = _$CacherStateCopyWithImpl;
@useResult
$Res call({
 Set<String> caching, Set<String> cached, Set<String> unsuccessful, int available
});




}
/// @nodoc
class _$CacherStateCopyWithImpl<$Res>
    implements $CacherStateCopyWith<$Res> {
  _$CacherStateCopyWithImpl(this._self, this._then);

  final CacherState _self;
  final $Res Function(CacherState) _then;

/// Create a copy of CacherState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? caching = null,Object? cached = null,Object? unsuccessful = null,Object? available = null,}) {
  return _then(_self.copyWith(
caching: null == caching ? _self.caching : caching // ignore: cast_nullable_to_non_nullable
as Set<String>,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as Set<String>,unsuccessful: null == unsuccessful ? _self.unsuccessful : unsuccessful // ignore: cast_nullable_to_non_nullable
as Set<String>,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CacherState].
extension CacherStatePatterns on CacherState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacherState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacherState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacherState value)  $default,){
final _that = this;
switch (_that) {
case _CacherState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacherState value)?  $default,){
final _that = this;
switch (_that) {
case _CacherState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> caching,  Set<String> cached,  Set<String> unsuccessful,  int available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacherState() when $default != null:
return $default(_that.caching,_that.cached,_that.unsuccessful,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> caching,  Set<String> cached,  Set<String> unsuccessful,  int available)  $default,) {final _that = this;
switch (_that) {
case _CacherState():
return $default(_that.caching,_that.cached,_that.unsuccessful,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> caching,  Set<String> cached,  Set<String> unsuccessful,  int available)?  $default,) {final _that = this;
switch (_that) {
case _CacherState() when $default != null:
return $default(_that.caching,_that.cached,_that.unsuccessful,_that.available);case _:
  return null;

}
}

}

/// @nodoc


class _CacherState extends CacherState with DiagnosticableTreeMixin {
  const _CacherState({final  Set<String> caching = const <String>{}, final  Set<String> cached = const <String>{}, final  Set<String> unsuccessful = const <String>{}, this.available = 0}): _caching = caching,_cached = cached,_unsuccessful = unsuccessful,super._();
  

 final  Set<String> _caching;
@override@JsonKey() Set<String> get caching {
  if (_caching is EqualUnmodifiableSetView) return _caching;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_caching);
}

 final  Set<String> _cached;
@override@JsonKey() Set<String> get cached {
  if (_cached is EqualUnmodifiableSetView) return _cached;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_cached);
}

 final  Set<String> _unsuccessful;
@override@JsonKey() Set<String> get unsuccessful {
  if (_unsuccessful is EqualUnmodifiableSetView) return _unsuccessful;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unsuccessful);
}

@override@JsonKey() final  int available;

/// Create a copy of CacherState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacherStateCopyWith<_CacherState> get copyWith => __$CacherStateCopyWithImpl<_CacherState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CacherState'))
    ..add(DiagnosticsProperty('caching', caching))..add(DiagnosticsProperty('cached', cached))..add(DiagnosticsProperty('unsuccessful', unsuccessful))..add(DiagnosticsProperty('available', available));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacherState&&const DeepCollectionEquality().equals(other._caching, _caching)&&const DeepCollectionEquality().equals(other._cached, _cached)&&const DeepCollectionEquality().equals(other._unsuccessful, _unsuccessful)&&(identical(other.available, available) || other.available == available));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_caching),const DeepCollectionEquality().hash(_cached),const DeepCollectionEquality().hash(_unsuccessful),available);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CacherState(caching: $caching, cached: $cached, unsuccessful: $unsuccessful, available: $available)';
}


}

/// @nodoc
abstract mixin class _$CacherStateCopyWith<$Res> implements $CacherStateCopyWith<$Res> {
  factory _$CacherStateCopyWith(_CacherState value, $Res Function(_CacherState) _then) = __$CacherStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> caching, Set<String> cached, Set<String> unsuccessful, int available
});




}
/// @nodoc
class __$CacherStateCopyWithImpl<$Res>
    implements _$CacherStateCopyWith<$Res> {
  __$CacherStateCopyWithImpl(this._self, this._then);

  final _CacherState _self;
  final $Res Function(_CacherState) _then;

/// Create a copy of CacherState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? caching = null,Object? cached = null,Object? unsuccessful = null,Object? available = null,}) {
  return _then(_CacherState(
caching: null == caching ? _self._caching : caching // ignore: cast_nullable_to_non_nullable
as Set<String>,cached: null == cached ? _self._cached : cached // ignore: cast_nullable_to_non_nullable
as Set<String>,unsuccessful: null == unsuccessful ? _self._unsuccessful : unsuccessful // ignore: cast_nullable_to_non_nullable
as Set<String>,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
