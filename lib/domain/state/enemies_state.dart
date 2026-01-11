import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/active_enemy.dart';

part 'enemies_state.freezed.dart';

/// Бизнес-состояние врагов
@freezed
sealed class EnemiesState with _$EnemiesState {
  const factory EnemiesState({
    /// Активные враги на поле (id -> данные)
    @Default({}) Map<String, ActiveEnemy> activeEnemies,
    /// Флаг активности спавна врагов
    @Default(false) bool isSpawning,
    /// ID последнего убитого врага (для уведомления Presentation об эффекте)
    String? lastKilledEnemyId,
    /// ID последнего врага, достигшего игрока
    String? lastCollidedEnemyId,
  }) = _EnemiesState;
}
