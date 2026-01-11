import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';

/// Состояние персонажа
@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    /// Угол направления игрока (в радианах)
    @Default(0.0) double angle,
    /// Текущее здоровье
    @Default(100) int health,
    /// Максимальное здоровье
    @Default(100) int maxHealth,
  }) = _PlayerState;

  const PlayerState._();

  /// Процент здоровья (0.0 - 1.0)
  double get healthPercent => health / maxHealth;
}
