# Freezed Cubit Skill

Use this skill when writing or editing any cubit in this project. All cubit states must use Freezed.

---

## When to use a union state vs a data class state

**Union (`@freezed` with multiple factory constructors)** — cubit has meaningfully different states (loading, loaded, error, etc.) where the set of available fields changes per state.

**Data class (`@freezed` with single factory constructor)** — cubit holds a single shape of data that updates over time (e.g. progress, a form, a counter).

---

## File structure

Every cubit lives in its own directory under `frontend/lib/bloc/`:

```
bloc/
  my_feature_cubit/
    my_feature_cubit.dart       ← cubit class
    my_feature_state.dart       ← state class (part of cubit)
    my_feature_cubit.freezed.dart  ← generated, do not edit
```

---

## Union state template

**`my_feature_state.dart`**
```dart
part of 'my_feature_cubit.dart';

@freezed
abstract class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState.initial() = _Initial;
  const factory MyFeatureState.loading() = _Loading;
  const factory MyFeatureState.loaded({required MyData data}) = _Loaded;
  const factory MyFeatureState.error({required String message}) = _Error;
}
```

**`my_feature_cubit.dart`**
```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_feature_cubit.freezed.dart';
part 'my_feature_state.dart';

class MyFeatureCubit extends Cubit<MyFeatureState> {
  MyFeatureCubit() : super(const MyFeatureState.initial());

  Future<void> load() async {
    emit(const MyFeatureState.loading());
    try {
      final data = await _someRepo.fetch();
      emit(MyFeatureState.loaded(data: data));
    } catch (e) {
      emit(MyFeatureState.error(message: e.toString()));
    }
  }
}
```

---

## Data class state template

**`my_feature_state.dart`**
```dart
part of 'my_feature_cubit.dart';

@freezed
abstract class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState({
    @Default(0.0) double progress,
    @Default('') String label,
  }) = _MyFeatureState;
}
```

Initial state: `const MyFeatureState()` — all `@Default` values apply.

---

## Naming conventions

| Variant purpose | Factory name |
|---|---|
| No data yet | `.initial()` |
| Async in-flight | `.loading()` |
| Success with data | `.loaded(...)` |
| Success, empty result | `.empty()` |
| Recoverable error | `.error(message: ...)` |

Keep variant names lowercase camelCase matching the factory constructor name.

---

## Emitting state in the cubit

```dart
// Union — named constructor
emit(const MyFeatureState.loading());
emit(MyFeatureState.loaded(data: result));
emit(MyFeatureState.error(message: e.toString()));

// Data class — copyWith for partial updates
emit(state.copyWith(progress: 0.75, label: '75%'));
```

---

## Reading state in BlocBuilder / widgets

Prefer `when` for exhaustive handling, `maybeWhen` when you only care about some variants:

```dart
BlocBuilder<MyFeatureCubit, MyFeatureState>(
  builder: (context, state) => state.when(
    initial: () => const SizedBox.shrink(),
    loading: () => const CircularProgressIndicator(),
    loaded: (data) => MyWidget(data: data),
    error: (message) => Text(message),
  ),
)
```

Partial handling:
```dart
state.maybeWhen(
  loaded: (data) => MyWidget(data: data),
  orElse: () => const SizedBox.shrink(),
)
```

Use `map` / `maybeMap` when you need access to the full state object rather than destructured fields.

---

## Part directives — exact order

In the cubit file, parts must appear in this order:
```dart
part 'my_feature_cubit.freezed.dart';  // generated
part 'my_feature_state.dart';           // hand-written
```

In the state file:
```dart
part of 'my_feature_cubit.dart';
```

---

## Codegen

After writing or editing any state file:

```sh
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Verify no issues:
```sh
fvm flutter analyze
```

---

## Adding helper methods to Freezed states

Use the private constructor trick to add computed getters or helper methods to a Freezed class:

```dart
@freezed
abstract class MyState with _$MyState {
  const MyState._(); // enables custom methods
  const factory MyState.play({required Track track}) = _Play;
  const factory MyState.pause({required Track track}) = _Pause;

  // Boolean helpers to avoid is-checks in UI
  bool get isPlay => maybeMap(play: (_) => true, orElse: () => false);
  bool get isPause => maybeMap(pause: (_) => true, orElse: () => false);
}
```

Note: if all variants share a field (e.g. `currentTrack`), Freezed generates the getter automatically — no need for a custom one.

---

## Checklist for a new cubit

- [ ] Directory named `<feature>_cubit/`
- [ ] State file uses `@freezed abstract class` with `_$ClassName` mixin
- [ ] Cubit file has both `part` directives (freezed first, state second)
- [ ] `freezed_annotation` imported in cubit file
- [ ] Initial state is a `const` constructor call
- [ ] All `emit()` calls use named factory constructors (union) or `copyWith` (data class)
- [ ] All widget usages use `when` / `maybeWhen` — no `is SubclassName` checks
- [ ] Codegen run, `.freezed.dart` file generated
- [ ] `fvm flutter analyze` passes
