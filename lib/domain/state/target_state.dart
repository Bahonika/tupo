import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_state.freezed.dart';

/// Состояние цели (выделенного врага)
@freezed
sealed class TargetState with _$TargetState {
  /// Нет активной цели
  const factory TargetState.none() = _None;

  /// Есть активная цель
  const factory TargetState.selected({
    /// ID врага-цели
    required String enemyId,

    /// Слово цели
    required String word,
  }) = _Selected;

  const TargetState._();

  /// Есть ли активная цель
  bool get hasTarget => map(
        none: (_) => false,
        selected: (_) => true,
      );
}
