import 'package:typo/domain/state/target_state.dart';

import '../../shared/utils/math_utils.dart';
import '../state_managers/player_state_manager.dart';
import '../state_managers/target_state_manager.dart';
import '../state_managers/typing_state_manager.dart';

/// Данные позиции врага для прицеливания
class EnemyPositionData {
  final String id;
  final String word;
  final double x;
  final double y;

  const EnemyPositionData({
    required this.id,
    required this.word,
    required this.x,
    required this.y,
  });
}

/// Interactor для логики прицеливания
class AimingInteractor {
  final PlayerStateManager _playerState;
  final TargetStateManager _targetState;
  final TypingStateManager _typingState;

  /// Допуск угла для выделения врага (в радианах, ~15 градусов)
  static const double aimTolerance = 0.26;

  AimingInteractor({
    required PlayerStateManager playerState,
    required TargetStateManager targetState,
    required TypingStateManager typingState,
  })  : _playerState = playerState,
        _targetState = targetState,
        _typingState = typingState;

  /// Обновить прицеливание на основе позиции мыши и врагов
  void updateAiming({
    required double mouseX,
    required double mouseY,
    required double centerX,
    required double centerY,
    required double screenWidth,
    required double screenHeight,
    required List<EnemyPositionData> enemies,
  }) {
    final playerAngle = MathUtils.angleBetweenPoints(
      centerX,
      centerY,
      mouseX,
      mouseY,
    );

    String? targetId;
    String? targetWord;
    double closestDistance = double.infinity;

    for (final enemy in enemies) {
      if (!_isEnemyVisible(enemy.x, enemy.y, screenWidth, screenHeight)) {
        continue;
      }

      final enemyAngle = MathUtils.angleBetweenPoints(
        centerX,
        centerY,
        enemy.x,
        enemy.y,
      );

      if (MathUtils.isAngleWithinTolerance(playerAngle, enemyAngle, aimTolerance)) {
        final distance = MathUtils.distanceBetweenPoints(
          centerX,
          centerY,
          enemy.x,
          enemy.y,
        );

        if (distance < closestDistance) {
          closestDistance = distance;
          targetId = enemy.id;
          targetWord = enemy.word;
        }
      }
    }

    _updateTarget(targetId, targetWord);

    _playerState.setAngle(playerAngle);
  }

  bool _isEnemyVisible(double x, double y, double screenWidth, double screenHeight) {
    return x >= 0 && x <= screenWidth && y >= 0 && y <= screenHeight;
  }

  void _updateTarget(String? targetId, String? targetWord) {
    final currentTargetId = _targetState.state.mapOrNull(
      selected: (selected) => selected.enemyId,
    );

    if (targetId != null && targetWord != null) {
      if (currentTargetId != targetId) {
        _targetState.setTarget(targetId, targetWord);
        _typingState.reset();
      }
    } else {
      if (currentTargetId != null) {
        _targetState.clearTarget();
        _typingState.reset();
      }
    }
  }
}
