import 'package:freezed_annotation/freezed_annotation.dart';

import 'enemy_data.dart';

part 'active_enemy.freezed.dart';

/// Тип движения врага
enum MovementType {
  straight,
  wavy,
}

/// Активный враг на игровом поле со всеми данными для бизнес-логики
@freezed
sealed class ActiveEnemy with _$ActiveEnemy {
  const factory ActiveEnemy({
    required EnemyData data,
    required double x,
    required double y,
    required double targetX,
    required double targetY,
    required double startX,
    required double startY,
    @Default(MovementType.straight) MovementType movementType,
    @Default(0.0) double movementProgress,
    @Default(false) bool isDestroyed,
    @Default(false) bool hasReachedTarget,
  }) = _ActiveEnemy;
}
