import 'dart:math';

import '../../data/sources/audio_service.dart';
import '../../shared/utils/math_utils.dart';
import '../models/active_enemy.dart';
import '../state_managers/enemies_state_manager.dart';
import '../state_managers/player_state_manager.dart';

/// Interactor для управления движением врагов и коллизиями
class EnemyMovementInteractor {
  final EnemiesStateManager _enemiesState;
  final PlayerStateManager _playerState;
  final AudioService _audioService;

  static const double _collisionRadius = 30;

  EnemyMovementInteractor({
    required EnemiesStateManager enemiesState,
    required PlayerStateManager playerState,
    required AudioService audioService,
  })  : _enemiesState = enemiesState,
        _playerState = playerState,
        _audioService = audioService;

  /// Обновить позиции всех врагов и проверить коллизии
  void update(double dt) {
    final enemies = _enemiesState.state.activeEnemies;
    if (enemies.isEmpty) return;

    final updatedEnemies = <String, ActiveEnemy>{};
    final collidedEnemyIds = <String>[];
    final enemiesToRemove = <String>[];

    for (final entry in enemies.entries) {
      final enemy = entry.value;

      if (enemy.hasReachedTarget) {
        enemiesToRemove.add(entry.key);
        continue;
      }

      if (enemy.isDestroyed) {
        updatedEnemies[entry.key] = enemy;
        continue;
      }

      final newPosition = _calculateNewPosition(enemy, dt);
      var updatedEnemy = enemy.copyWith(
        x: newPosition.x,
        y: newPosition.y,
        movementProgress: enemy.movementProgress + dt,
      );

      final distance = MathUtils.distanceBetweenPoints(
        newPosition.x,
        newPosition.y,
        enemy.targetX,
        enemy.targetY,
      );

      if (distance < _collisionRadius) {
        updatedEnemy = updatedEnemy.copyWith(hasReachedTarget: true);
        collidedEnemyIds.add(entry.key);
      }

      updatedEnemies[entry.key] = updatedEnemy;
    }

    _enemiesState.updateEnemies(updatedEnemies);

    for (final enemyId in collidedEnemyIds) {
      final enemy = updatedEnemies[enemyId];
      if (enemy != null) {
        _playerState.takeDamage(enemy.data.damage);
        _audioService.playSound(SoundEffect.playerHit);
        _enemiesState.notifyEnemyCollided(enemyId);
      }
    }
  }

  /// Вычислить новую позицию врага
  ({double x, double y}) _calculateNewPosition(ActiveEnemy enemy, double dt) {
    final dx = enemy.targetX - enemy.startX;
    final dy = enemy.targetY - enemy.startY;
    final totalDistance = sqrt(dx * dx + dy * dy);

    if (totalDistance == 0) {
      return (x: enemy.x, y: enemy.y);
    }

    final dirX = dx / totalDistance;
    final dirY = dy / totalDistance;

    final moveDistance = enemy.data.speed * dt;
    var newX = enemy.x + dirX * moveDistance;
    var newY = enemy.y + dirY * moveDistance;

    if (enemy.movementType == MovementType.wavy) {
      final perpX = -dirY;
      final perpY = dirX;

      final waveOffset = sin(enemy.movementProgress * 3) * 50;
      newX += perpX * waveOffset * dt;
      newY += perpY * waveOffset * dt;
    }

    return (x: newX, y: newY);
  }

  /// Уничтожить врага (при убийстве)
  void destroyEnemy(String enemyId) {
    _enemiesState.markEnemyDestroyed(enemyId);
  }

  /// Очистить всех врагов
  void clearAllEnemies() {
    _enemiesState.clearAllEnemies();
  }
}
