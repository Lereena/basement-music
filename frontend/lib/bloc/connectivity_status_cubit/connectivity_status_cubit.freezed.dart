// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connectivity_status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectivityStatusState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ConnectivityStatusState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectivityStatusState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ConnectivityStatusState()';
}


}

/// @nodoc
class $ConnectivityStatusStateCopyWith<$Res>  {
$ConnectivityStatusStateCopyWith(ConnectivityStatusState _, $Res Function(ConnectivityStatusState) __);
}


/// Adds pattern-matching-related methods to [ConnectivityStatusState].
extension ConnectivityStatusStatePatterns on ConnectivityStatusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _HasConnection value)?  hasConnection,TResult Function( _NoConnection value)?  noConnection,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _HasConnection() when hasConnection != null:
return hasConnection(_that);case _NoConnection() when noConnection != null:
return noConnection(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _HasConnection value)  hasConnection,required TResult Function( _NoConnection value)  noConnection,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _HasConnection():
return hasConnection(_that);case _NoConnection():
return noConnection(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _HasConnection value)?  hasConnection,TResult? Function( _NoConnection value)?  noConnection,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _HasConnection() when hasConnection != null:
return hasConnection(_that);case _NoConnection() when noConnection != null:
return noConnection(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  hasConnection,TResult Function()?  noConnection,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _HasConnection() when hasConnection != null:
return hasConnection();case _NoConnection() when noConnection != null:
return noConnection();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  hasConnection,required TResult Function()  noConnection,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _HasConnection():
return hasConnection();case _NoConnection():
return noConnection();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  hasConnection,TResult? Function()?  noConnection,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _HasConnection() when hasConnection != null:
return hasConnection();case _NoConnection() when noConnection != null:
return noConnection();case _:
  return null;

}
}

}

/// @nodoc


class _Initial with DiagnosticableTreeMixin implements ConnectivityStatusState {
  const _Initial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ConnectivityStatusState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ConnectivityStatusState.initial()';
}


}




/// @nodoc


class _HasConnection with DiagnosticableTreeMixin implements ConnectivityStatusState {
  const _HasConnection();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ConnectivityStatusState.hasConnection'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HasConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ConnectivityStatusState.hasConnection()';
}


}




/// @nodoc


class _NoConnection with DiagnosticableTreeMixin implements ConnectivityStatusState {
  const _NoConnection();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ConnectivityStatusState.noConnection'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ConnectivityStatusState.noConnection()';
}


}




// dart format on
