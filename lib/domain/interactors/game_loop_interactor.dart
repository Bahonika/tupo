import '../state_managers/enemies_state_manager.dart';
import '../state_managers/input_state_manager.dart';
import 'aiming_interactor.dart';
import 'enemy_movement_interactor.dart';
import 'spawning_interactor.dart';

/// Interactor для управления игровым циклом (update loop)
class GameLoopInteractor {
  final EnemyMovementInteractor _enemyMovementInteractor;
  final SpawningInteractor _spawningInteractor;
  final AimingInteractor _aimingInteractor;
  final InputStateManager _inputState;
  final EnemiesStateManager _enemiesState;

  GameLoopInteractor({
    required EnemyMovementInteractor enemyMovementInteractor,
    required SpawningInteractor spawningInteractor,
    required AimingInteractor aimingInteractor,
    required InputStateManager inputState,
    required EnemiesStateManager enemiesState,
  })  : _enemyMovementInteractor = enemyMovementInteractor,
        _spawningInteractor = spawningInteractor,
        _aimingInteractor = aimingInteractor,
        _inputState = inputState,
        _enemiesState = enemiesState;

  void update({
    required double dt,
    required double screenWidth,
    required double screenHeight,
  }) {
    _enemyMovementInteractor.update(dt);
    _spawningInteractor.updateSpawnTimer(dt, screenWidth, screenHeight);

    final mousePosition = _inputState.state.mousePosition;
    if (mousePosition != null) {
      final centerX = screenWidth / 2;
      final centerY = screenHeight / 2;
      final enemyPositions = _enemiesState.state.activeEnemies.entries
          .where((e) => !e.value.isDestroyed && !e.value.hasReachedTarget)
          .map((e) => EnemyPositionData(
                id: e.key,
                word: e.value.data.word,
                x: e.value.x,
                y: e.value.y,
              ))
          .toList();

      _aimingInteractor.updateAiming(
        mouseX: mousePosition.x,
        mouseY: mousePosition.y,
        centerX: centerX,
        centerY: centerY,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        enemies: enemyPositions,
      );
    }
  }
}
